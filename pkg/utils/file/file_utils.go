package file_utils

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"

	"aqary_admin/config"
	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/security"

	"mime/multipart"

	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob"
	"github.com/gin-gonic/gin"
)

// ***************** Single Image Upload External Bucket API
func UploadSingleFile(c *gin.Context, file *multipart.FileHeader, path string) (string, error) {
	authPayload := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
	if authPayload.Username != middleware.TestUser {
		body := &bytes.Buffer{}
		writer := multipart.NewWriter(body)
		// path is the folder name for image/file sections
		writer.WriteField("path", path)
		part, err := writer.CreateFormFile("file", file.Filename)
		if err != nil {
			return "", fmt.Errorf("error while creating form file:%v", err)
		}
		// log.Println("testing file", file)

		src, err := file.Open()
		if err != nil {
			log.Println(fmt.Errorf("error while opening file:%v", err))
			return "", fmt.Errorf("error while opening file:%v", err)
		}
		defer src.Close()

		_, err = io.Copy(part, src)
		if err != nil {
			return "", fmt.Errorf("error while copying file:%v", err)
		}
		writer.Close()

		// Send the form data (including the image) to the external API
		apiURL := fmt.Sprintf("https://%v/bucket/v1/uploadSingleFile", utils.CURRENT_IP)
		req, err := http.NewRequest("POST", apiURL, body)
		if err != nil {
			return "", fmt.Errorf("error while request:%v", err)
		}
		req.Header.Set("Content-Type", writer.FormDataContentType())

		client := &http.Client{}
		resp, err := client.Do(req)
		if err != nil {
			return "", fmt.Errorf("error while response:%v", err)
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			return "", fmt.Errorf("error status is no ok")
		}

		// Read the response body
		responseBody, err := io.ReadAll(resp.Body)
		if err != nil {
			return "", err
		}

		responseString := string(responseBody)

		parts := strings.Split(responseString, `"`)

		var finalString string

		// Extract the second part
		if len(parts) >= 4 {
			finalString = parts[3]
		} else {
			fmt.Println("Invalid input string")
		}

		if path != "" {
			return utils.BASE_URL + path + "/" + finalString, nil
		} else {
			return utils.BASE_URL + finalString, nil
		}

	} else {
		return file.Filename, nil
	}

}

func UploadSingleFileToABS(c *gin.Context, fileHeader *multipart.FileHeader, kPath string) (string, error) {

	serviceClient, err := azblob.NewClientFromConnectionString(config.AppConfig.AzureStorageConnStr, nil)
	if err != nil {
		log.Println("testing service client err ", err)
		return "", err
	}

	log.Println("testing file header ", fileHeader.Filename)

	// Open the uploaded file
	srcFile, err := fileHeader.Open()
	if err != nil {
		log.Println("testing src file open  err ", err)
		return "", err
	}
	defer srcFile.Close()

	var blobName = utils.GenerateBlobName(kPath, fileHeader.Filename)

	// Upload the file to a block blob
	_, err = serviceClient.UploadStream(c, "upload", blobName, srcFile, &azblob.UploadStreamOptions{
		BlockSize:   int64(1024 * 1024), // 1MB block size
		Concurrency: 3,
	})

	if err != nil {
		log.Println("testing upload stream  err ", err)
		return "", err
	}

	// var serviceFullURL = serviceClient.URL() + "/upload/" + blobName
	var serviceFullURL = serviceClient.URL() + "upload/" + blobName
	return serviceFullURL, nil
}

func UploadFileToABS(c context.Context, file *os.File, kPath string) (string, error) {
	serviceClient, err := azblob.NewClientFromConnectionString(config.AppConfig.AzureStorageConnStr, nil)
	if err != nil {
		log.Println("Azure Blob service client error:", err)
		return "", err
	}

	fileStat, err := file.Stat()
	if err != nil {
		return "", err
	}
	fileSize := fileStat.Size()
	fileBuffer := make([]byte, fileSize)
	_, err = file.Read(fileBuffer)
	if err != nil {
		return "", err
	}

	_, err = serviceClient.UploadBuffer(c, "upload", kPath, fileBuffer, &azblob.UploadBufferOptions{
		BlockSize:   int64(1024 * 1024), // 1MB block size
		Concurrency: 3,
	})
	if err != nil {
		log.Println("Azure Blob upload error:", err)
		return "", err
	}

	fileURL := fmt.Sprintf("%supload/%s", serviceClient.URL(), kPath)
	return fileURL, nil
}
