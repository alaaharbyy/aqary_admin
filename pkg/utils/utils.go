package utils

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"math"
	"mime/multipart"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"reflect"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"
	"unicode"

	"aqary_admin/config"
	"aqary_admin/internal/delivery/redis"
	queue "aqary_admin/internal/delivery/redis"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/internal/usecases/user/auth/extras"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/99designs/gqlgen/graphql"
	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob"
	"github.com/RediSearch/redisearch-go/v2/redisearch"
	"github.com/gin-gonic/gin"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/mrz1836/go-sanitize"
	"go.uber.org/zap"
	"golang.org/x/exp/rand"
	"golang.org/x/text/runes"
	"golang.org/x/text/transform"
	"golang.org/x/text/unicode/norm"
	// "aqary_admin/old_repo/user/auth/extras"
	// "aqary_admin/pkg/utils/constants"
	// "bytes"
	// "context"
	// "encoding/json"
	// "errors"
	// "fmt"
	// "io"
	// "log"
	// "math"
	// "math/rand"
	// "mime/multipart"
	// "net/http"
	// "os"
	// "path/filepath"
	// "reflect"
	// "slices"
	// "strconv"
	// "strings"
	// "sync"
	// "time"
	// "github.com/99designs/gqlgen/graphql"
	// "github.com/Azure/azure-sdk-for-go/sdk/storage/azblob"
	// "github.com/gofrs/uuid"
	// "github.com/jackc/pgx/v5/pgtype"
	// "github.com/mrz1836/go-sanitize"
)

var alphabet = "abcdefghijklmnopqrstuvwxyz0123456789~!@#$%&*()-_+="
var TimeFormatLayout = "2006-01-02"

var CURRENT_IP = "cmd.aqaryservices.com"
var FILE_PATH = "https://" + CURRENT_IP + "/upload/"

var DOMAIN = "https://" + CURRENT_IP + "/"
var BASE_URL = DOMAIN + "upload/"

// type RefNo string
var IS_TEST_MODE = false

var (
	specialCharsRegex = regexp.MustCompile(`[^a-zA-Z0-9\s]`)
	multiSpaceRegex   = regexp.MustCompile(`\s+`)
	wordRegex         = regexp.MustCompile(`(\w+)`)
)

const (

	// @ Quality score for property & unit
	// ! maximum value range are
	// @ title => 60 characters
	// @ description => 2000 characters
	// @ address => 4 (country,state,city & community)
	// @  media => 30 images
	// ! ************************
	TITLE_MAX_LIMIT                  = 60
	DESCRIPTION_MAX_LIMIT            = 2000
	ADDRESS_MAX_LIMIT                = 4
	MEDIA_MAX_LIMIT                  = 30
	SECTION_PERMISSION_CACHE_KEY     = "sectionPermissions:"
	PERMISSION_CACHE_KEY             = "permissions:"
	SUB_SECTION_PERMISSION_CACHE_KEY = "subSectionPermissions:"
)

//	ErrResponseSwagger represents the structure of error responses
//
// swagger:model
type ErrResponseSwagger struct {
	Error string `json:"error" example:"any error message"`
}

// random strings
func RandomString(n int) string {
	var sb strings.Builder

	k := len(alphabet)

	for i := 0; i < n; i++ {
		c := alphabet[rand.Intn(k)]
		sb.WriteByte(c)
	}

	return sb.String()
}

func RandomInteger(n int) int {
	var sb strings.Builder

	ran := rand.Int63n(999999999999999999)

	strng := strconv.FormatInt(ran, 10)
	k := len(strng)

	for i := 0; i < n; i++ {
		c := strng[rand.Intn(k)]
		sb.WriteByte(c)
	}
	finalInt, _ := strconv.Atoi(sb.String())
	return finalInt
}

// rename file
func RenameFile(file *multipart.FileHeader) string {
	uuid, _ := uuid.NewV7()

	fileExtension := filepath.Ext(file.Filename)

	newFileName := uuid.String() + fileExtension

	return newFileName
}

type CustomMap[K comparable, V any] struct {
	Data map[K]V
}

// dynamic key value map
func NewCustomMap[K comparable, V any]() *CustomMap[K, V] {
	return &CustomMap[K, V]{
		Data: make(map[K]V),
	}
}

func (c *CustomMap[K, V]) Insert(k K, v V) {
	c.Data[k] = v
}

// delete all file from upload directory
func DeleteAllFiles(oldFileURLs []string) (string, error) {
	for i := range oldFileURLs {
		DeleteFile(oldFileURLs[i])
	}
	return "deleted successfully", nil
}

// check if file exist or not
func IsFileExist(fileURL string) bool {
	_, err := os.Stat("upload/" + fileURL)
	if err != nil {
		// Checking if the given file exists or not
		// Using IsNotExist() function
		if os.IsNotExist(err) {
			log.Println("File error :: ", err)
			return false
		}
		return false
	}
	return true
}

// delete single file from upload directory
func DeleteFile(fileURL string) (string, error) {
	if IsFileExist(fileURL) {
		err := os.Remove("upload/" + fileURL)
		if err != nil {
			return "", err
		}
		log.Println(fileURL, ":::", "deleted successfully from server")
	}
	return "deleted successfully", nil
}

// convert interface{} to []string
func InterfaceToStringList(input interface{}) []string {

	var finalResult []string
	if input != nil {
		inputList := input.([]interface{})
		for i := range inputList {
			value := inputList[i].(string)
			finalResult = append(finalResult, value)
		}
	} else {
		println("test")
	}
	return finalResult
}

// remove string from []string
func RemoveItemFromStringList(list []string, item string) []string {

	var distinationList []string

	for i := range list {
		if list[i] != item {
			distinationList = append(distinationList, list[i])
		}
	}

	return distinationList
}

// check if string exist in []string
func CheckIfItemExist(list []string, item string) bool {
	for i := range list {
		if list[i] == item {
			return true
		}
	}
	return false
}

// reference number || e.g. prefex is PRO,AP,VI etc
func GenerateReferenceNumber(prefex string) string {
	// ? current time
	timestamp := time.Now().UTC().Format("20060102150405")
	// ? currenct time + currenct nano seconds
	uniqueID := fmt.Sprintf("%s%04d", timestamp, time.Now().Nanosecond())
	// ? combine random integer
	generatedRefNumber := prefex + "_" + uniqueID[14:18] + strconv.Itoa(RandomInteger(3))

	return generatedRefNumber
}

// returns only alpha characters with space. Valid characters are a-z and A-Z.
func SanitizeString(s string) string {
	return sanitize.Alpha(s, true)
}

// returns only alpha characters without space. Valid characters are a-z and A-Z.
func SanitizeStringWithSpace(s string) string {
	return sanitize.Alpha(s, false)
}

// SanitizeDecimal returns sanitized decimal/float values in either positive or negative.
func SanitizeDecimal(s string) string {
	return sanitize.Decimal(s)
}

// func InterfaceToIntList(input interface{}) []int32 {
// 	var finalResult []int32
// 	inputList := input.([]interface{})
// 	for i := range inputList {
// 		value := inputList[i].(map[string]any)["id"].(float64)
// 		finalResult = append(finalResult, int32(value))
// 	}

//		return finalResult
//	}

// func BuildError(c *gin.Context, err error) error {
// 	switch err {

// 	default:
// 		return
// 	}
// }

// ! to check if int is available in the list or not .....
func ContainsInt(list []int64, target int64) bool {
	for _, item := range list {
		if item == target {
			return true
		}
	}
	return false
}

// ! to check if string is available in the list or not .....
func ContainsString(s []string, target string) bool {
	for _, item := range s {
		if item == target {
			return true
		}
	}
	return false
}

// ! to make a unique list or remove duplication
func MakeUnique(input []int64) []int64 {
	uniqueMap := make(map[int64]bool)
	result := []int64{}

	for _, num := range input {
		if !uniqueMap[num] {
			uniqueMap[num] = true
			result = append(result, num)
		}
	}

	return result
}

// ! to make a unique list or remove duplication
func MakeStringUnique(input []string) []string {
	if input != nil {
		uniqueMap := make(map[string]bool)
		result := []string{}

		for _, num := range input {
			if !uniqueMap[num] {
				uniqueMap[num] = true
				result = append(result, num)
			}
		}
		return result
	}
	return nil
}

func HaveCommonValues(slice1, slice2 []int64) bool {
	// Create a map to store values from slice1
	valueMap := make(map[int64]bool)

	// Populate the map with values from slice1
	for _, value := range slice1 {
		valueMap[value] = true
	}

	// Check if any value from slice2 exists in the map
	for _, value := range slice2 {
		if _, exists := valueMap[value]; exists {
			return true
		}
	}

	// No common values found
	return false
}

// custom error for binding

func CustomBindingFormError(err error, model any) string {
	errMessage := err.Error()
	// Extract field name from error message
	if parts := strings.Split(errMessage, " "); len(parts) >= 2 {
		field := parts[1]
		splittedField := strings.Split(field, ".")
		if len(splittedField) > 1 {
			fieldName := SanitizeString(splittedField[1])
			ref, found := reflect.TypeOf(model).FieldByName(fieldName)
			if !found {
				return "Invalid input"
			}

			tagValue := ref.Tag.Get("form")
			value := strings.ReplaceAll(tagValue, "_", " ")
			return fmt.Sprintf("Field '" + value + "' is required")
		} else {
			return errMessage
		}
	}

	return "Invalid input"
}

func CustomBindingJsonError(err error, model any) string {
	errMessage := err.Error()
	// Extract field name from error message
	if parts := strings.Split(errMessage, " "); len(parts) >= 2 {
		field := parts[1]
		splittedField := strings.Split(field, ".")
		if len(splittedField) > 1 {
			fieldName := SanitizeString(splittedField[1])
			ref, found := reflect.TypeOf(model).FieldByName(fieldName)
			if !found {
				return "Invalid input"
			}

			tagValue := ref.Tag.Get("json")
			return fmt.Sprintf("Field '" + tagValue + "' is required")
		} else {
			return errMessage
		}
	}

	return "Invalid input"
}

func getFieldName(errorMessage string) string {
	parts := strings.Split(errorMessage, " ")
	if len(parts) >= 2 {
		return parts[1]
	}
	return ""
}

// ***************** Single Image Upload External Bucket API

func UploadSingleFileGraphql(file *graphql.Upload, path string) (string, error) {

	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	// path is the folder name for image/file sections
	writer.WriteField("path", path)
	part, err := writer.CreateFormFile("file", file.Filename)
	if err != nil {
		return "", fmt.Errorf("error while creating form file:%v", err)
	}
	log.Println("testing file", file)

	// src, err := file.Open()
	// if err != nil {
	// 	log.Println(fmt.Errorf("error while opening file:%v", err))
	// 	return "", fmt.Errorf("error while opening file:%v", err)
	// }
	// defer src.Close()

	_, err = io.Copy(part, file.File)
	if err != nil {
		return "", fmt.Errorf("error while copying file:%v", err)
	}
	writer.Close()

	// Send the form data (including the image) to the external API
	apiURL := fmt.Sprintf("https://%v/bucket/v1/uploadSingleFile", CURRENT_IP)
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
		return BASE_URL + path + "/" + finalString, nil
	} else {
		return BASE_URL + finalString, nil
	}
}

// ***************** Delete single  image from  External Bucket API

func DeleteSingleFile(fileName string) (string, error) {

	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)

	writer.WriteField("file", fileName)
	writer.Close()

	// Send the form data (including the image) to the external API
	apiURL := fmt.Sprintf("https://%v/bucket/v1/deleteSingleFile", CURRENT_IP)
	req, err := http.NewRequest("DELETE", apiURL, body)
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", writer.FormDataContentType())

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", err
	}

	// Read the response body
	responseBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return string(responseBody), nil
}

func DeleteSingleFileFromABS(fileName string) (string, error) {
	connectionString := os.Getenv("AZURE_STORAGE_CONNECTION_STRING")
	serviceClient, err := azblob.NewClientFromConnectionString(connectionString, nil)
	if err != nil {
		return "", err
	}
	// Delete the blob
	prefix := "https://aqarydashboard.blob.core.windows.net/upload/"

	// TODO : In database both domain are exist
	// TODO : old domain api.aqaryservices.com will be removed from database
	if !strings.Contains(fileName, prefix) {
		return "", nil
	}

	trimmedURL := strings.TrimPrefix(fileName, prefix)
	_, err = serviceClient.DeleteBlob(context.Background(), "upload", trimmedURL, nil)

	if err != nil {
		return "", err
	}

	return "", nil
}

func DeleteMultipleFilesFromABS(fileNames []string) error {
	var err error = nil
	for i := 0; i < len(fileNames); i++ {
		_, err = DeleteSingleFileFromABS(fileNames[i])
	}
	return err
}

// ***************** Mulitple Image/File Upload External Bucket API
func UploadMulitpleFile(files []*multipart.FileHeader, path string) ([]string, error) {

	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	writer.WriteField("path", path)
	for _, file := range files {
		part, err := writer.CreateFormFile("file[]", file.Filename)
		if err != nil {
			return []string{}, err
		}
		src, err := file.Open()
		if err != nil {
			return []string{}, err
		}
		defer src.Close()

		_, err = io.Copy(part, src)
		if err != nil {
			return []string{}, err
		}
	}
	writer.Close()

	// Send the form data (including the image) to the external API
	apiURL := fmt.Sprintf("https://%v/bucket/v1/uploadMultipleFile", CURRENT_IP)
	req, err := http.NewRequest("POST", apiURL, body)
	if err != nil {
		return []string{}, err
	}
	req.Header.Set("Content-Type", writer.FormDataContentType())

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return []string{}, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return []string{}, err
	}

	// Read the response body
	responseBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return []string{}, err
	}

	var result map[string][]string
	// ! it will convert into list of strings
	json.Unmarshal(responseBody, &result)

	for i := range result["data"] {
		result["data"][i] = BASE_URL + path + "/" + result["data"][i]
	}

	return result["data"], nil
}

func UploadMultipleFileToABS(fileHeader []*multipart.FileHeader, kPath string) ([]string, error) {
	var (
		results []string
		wg      sync.WaitGroup
		mu      sync.Mutex
		errCh   = make(chan error, len(fileHeader))
	)

	connectionString := config.AppConfig.AzureStorageConnStr
	serviceClient, err := azblob.NewClientFromConnectionString(connectionString, nil)
	if err != nil {
		return nil, err
	}

	for i := 0; i < len(fileHeader); i++ {
		wg.Add(1)
		go func(i int) {
			defer wg.Done()

			srcFile, err := fileHeader[i].Open()
			if err != nil {
				errCh <- err
				return
			}
			defer srcFile.Close()

			blobName := GenerateBlobName(kPath, fileHeader[i].Filename)

			// Adjust block size dynamically based on the file size, here assuming a default for simplicity
			const defaultBlockSize = int64(8 * 1024 * 1024) // 8MB
			options := &azblob.UploadStreamOptions{
				BlockSize: defaultBlockSize,
			}

			_, err = serviceClient.UploadStream(context.Background(), "upload", blobName, srcFile, options)
			if err != nil {
				errCh <- err
				return
			}

			// fullURL := fmt.Sprintf("%s/upload/%s", serviceClient.URL(), blobName)
			fullURL := fmt.Sprintf("%supload/%s", serviceClient.URL(), blobName)

			mu.Lock()
			results = append(results, fullURL)
			mu.Unlock()
		}(i)
	}

	wg.Wait()
	close(errCh)

	if len(errCh) > 0 {
		return nil, <-errCh
	}

	return results, nil
}

func UploadMultipleFileToABSGraphQL(fileHeader *graphql.Upload, kPath string) (string, error) {
	var (
		results string
		// wg      sync.WaitGroup
		// mu      sync.Mutex
		// errCh   = make(chan error, len(fileHeader))
	)

	connectionString := os.Getenv("AZURE_STORAGE_CONNECTION_STRING")
	serviceClient, err := azblob.NewClientFromConnectionString(connectionString, nil)
	if err != nil {
		return "", err
	}

	srcFile := fileHeader

	blobName := GenerateBlobName(kPath, fileHeader.Filename)

	// Adjust block size dynamically based on the file size, here assuming a default for simplicity
	const defaultBlockSize = int64(8 * 1024 * 1024) // 8MB
	options := &azblob.UploadStreamOptions{
		BlockSize: defaultBlockSize,
	}

	_, err = serviceClient.UploadStream(context.Background(), "upload", blobName, srcFile.File, options)
	if err != nil {
		return "", err
	}

	// fullURL := fmt.Sprintf("%s/upload/%s", serviceClient.URL(), blobName)
	fullURL := fmt.Sprintf("%supload/%s", serviceClient.URL(), blobName)

	results = fullURL

	return results, nil
}

func GenerateBlobName(kPath string, FileName string) string {
	uuid, _ := uuid.NewV7()
	return fmt.Sprintf("%v/%v%v%v", strings.Join(strings.Fields(kPath), ""), time.Now().UnixNano(), uuid, strings.Join(strings.Fields(FileName), ""))
}

func DeleteMultipleFile(fileNames []string) error {

	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)

	for _, fileName := range fileNames {
		writer.WriteField("file[]", fileName)
	}

	writer.Close()

	// Send the form data (including the image) to the external API
	apiURL := fmt.Sprintf("https://%v/bucket/v1/deleteAllFile", CURRENT_IP)
	req, err := http.NewRequest("DELETE", apiURL, body)
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", writer.FormDataContentType())

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return err
	}

	return nil
}

func ExtractFileNameFromUrlList(files []string) []string {
	var allFiles []string
	for _, file := range files {
		// only extracting filename from url....
		splitNames := strings.Split(file, "/")
		splitName := splitNames[len(splitNames)-1]
		allFiles = append(allFiles, splitName)
	}

	return allFiles
}

func ExtractFileNameFromUrl(file string) string {

	// only extracting filename from url....
	splitNames := strings.Split(file, "/")
	splitName := splitNames[len(splitNames)-1]

	return splitName
}

// ! custom Ternary operator.....
func Ternary[T any](cond bool, a, b T) T {
	if cond {
		return a
	}
	return b
}

// check100 checks if a summation of a list of percentages is equal to 100
func Check100(numbers []float64) (bool, error) {
	if len(numbers) == 0 {
		return false, errors.New("empty slice")
	}

	sum := 0.0

	// Calculate the sum of elements in the slice
	for _, num := range numbers {
		sum += num
	}

	// Check if the sum is equal to 100
	if sum == 100.0 {
		return true, nil
	}

	return false, errors.New("sum is not equal to 100")
}

// areDatesInOrder checks a map of dates and checks whether they are in ascending order
func AreDatesInOrder(dateMap map[int]time.Time) error {
	var prevDate time.Time

	errChan := make(chan error)

	var wg sync.WaitGroup
	for i := range dateMap {
		wg.Add(1)
		go func(i int) {

			if dateMap[i].Compare(prevDate) == -1 {
				errChan <- errors.New("dates are not in ascending======= order")
				// return errors.New("dates are not in ascending======= order")
			}
			prevDate = dateMap[i]
		}(i)
	}

	go func() {
		wg.Wait()
		close(errChan)
	}()

	return <-errChan

	// return nil
}

// areTwoDatesInOrder checks two dates if they are in order
func AreTwoDatesInOrder(date1, date2 time.Time) error {
	if !date1.Before(date2) {
		return nil
	}
	return errors.New("dates are not in ascending order")
}

func AddPercent(s string) string {
	return "%" + s + "%"
}

func InterfaceToPgInt8(value interface{}) (pgtype.Int8, error) {
	var int8Val pgtype.Int8
	switch v := value.(type) {
	case int8:
		int8Val.Int64 = int64(v)
		int8Val.Valid = true
	case int:
		int8Val.Int64 = int64(v)
		int8Val.Valid = true
	case int64:
		if v < math.MinInt8 || v > math.MaxInt8 {
			return int8Val, fmt.Errorf("value %d overflows pgtype.Int8", v)
		}
		int8Val.Int64 = v
		int8Val.Valid = true
	case string:
		i, err := strconv.ParseInt(v, 10, 8) // Parse as int8 with base 10
		if err != nil {
			return int8Val, fmt.Errorf("error converting string to int8: %w", err)
		}
		int8Val.Int64 = i
		int8Val.Valid = true
	case nil:
		int8Val.Valid = false
	default:
		// Handle unsupported types (optional)
		// You can return an error or set a specific status based on your needs
		return int8Val, fmt.Errorf("unsupported type for pgtype.Int8 conversion: %T", value)
	}
	return int8Val, nil
}
func InterfaceToPgText(value interface{}) (pgtype.Text, error) {
	var text pgtype.Text
	switch v := value.(type) {
	case string:
		text.String = v
		text.Valid = true
	case []byte:
		text.String = string(v)
		text.Valid = true
	case fmt.Stringer:
		text.String = v.String()
		text.Valid = true
	case nil:
		text.Valid = false
	default:
		return text, fmt.Errorf("unsupported type for pgtype.Text conversion: %T", value)
	}
	return text, nil
}

func InterfaceToPgBool(value interface{}) (pgtype.Bool, error) {
	var boolVal pgtype.Bool
	switch v := value.(type) {
	case bool:
		boolVal.Bool = v
		boolVal.Valid = true
	case string:
		b, err := strconv.ParseBool(v)
		if err != nil {
			return boolVal, fmt.Errorf("error converting string to bool: %w", err)
		}
		boolVal.Bool = b
		boolVal.Valid = true
	case nil:
		boolVal.Valid = false
	default:
		return boolVal, fmt.Errorf("unsupported type for pgtype.Bool conversion: %T", value)
	}
	return boolVal, nil
}

func ContainsIdForCustomSectionPermisison(list []extras.CustomSectionPermission, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}

func ContainSectionId(list []extras.CustomSectionPermission, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}

// FindCommonPermissions takes two slices of permissions (represented as int64) and returns a new slice containing only the permissions that are common to both.
func FindCommonPermissions(list1, list2 []int64) []int64 {
	common := []int64{} // Initialize an empty slice for common permissions

	// Create a map to store the permissions of the first list for quick lookup
	permissionsMap := make(map[int64]bool)
	for _, perm := range list1 {
		permissionsMap[perm] = true
	}

	// Iterate over the second list and check if the permission exists in the map (first list)
	for _, perm := range list2 {
		if _, found := permissionsMap[perm]; found {
			// If found, add to the common permissions list
			common = append(common, perm)
		}
	}

	return common
}

func FindByID(structs []sqlc.SubSectionMv, id int64) sqlc.SubSectionMv {
	for _, s := range structs {
		if s.ID == id {
			return s
		}
	}
	return sqlc.SubSectionMv{}
}

type FormatAddress struct {
	Country, State, City, Community, SubCommunity string
}

func (a FormatAddress) String() string {
	var parts []string

	if a.SubCommunity != "" {
		parts = append(parts, a.SubCommunity)
	}
	if a.Community != "" {
		parts = append(parts, a.Community)
	}
	if a.City != "" {
		parts = append(parts, a.City)
	}
	if a.State != "" {
		parts = append(parts, a.State)
	}
	if a.Country != "" {
		parts = append(parts, a.Country)
	}

	return strings.Join(parts, ",")

}

// SliceContains checks if a slice of int64 contains a specific value
func SliceContains(slice []int64, item int64) bool {
	for _, v := range slice {
		if v == item {
			return true
		}
	}
	return false
}

// If you need to use this function with other types, you can create generic versions:

// SliceContainsInt checks if a slice of int contains a specific value
func SliceContainsInt(slice []int, item int) bool {
	for _, v := range slice {
		if v == item {
			return true
		}
	}
	return false
}

// SliceContainsString checks if a slice of string contains a specific value
func SliceContainsString(slice []string, item string) bool {
	for _, v := range slice {
		if v == item {
			return true
		}
	}
	return false
}

// If you're using Go 1.18 or later, you can use a generic function instead:

// SliceContainsGeneric checks if a slice contains a specific value
func SliceContainsGeneric[T comparable](slice []T, item T) bool {
	for _, v := range slice {
		if v == item {
			return true
		}
	}
	return false
}

// Helper functions to safely handle nil pointers
func SafeInt64(ptr *int64) int64 {
	if ptr != nil {
		return *ptr
	}
	return 0
}

func SafeInt32(ptr *int32) int32 {
	if ptr != nil {
		return *ptr
	}
	return 0
}

func SafeBool(ptr *bool) bool {
	if ptr != nil {
		return *ptr
	}
	return false
}

// {"base_currency": 1, "default_currency":2, "unit_of_measure": "sqft" , "decimals":2 }
type DefaultSettings struct {
	CurrencyID     int64  `json:"default_currency"`
	BaseCurrencyID int64  `json:"base_currency"`
	DecimalPlace   uint   `json:"decimals"`
	Measurement    string `json:"unit_of_measure"`
}
type Facts struct {
	//facts
	Bedroom         string    `json:"bedroom,omitempty"`
	Bathroom        int64     `json:"bathroom,omitempty"`
	PlotArea        float64   `json:"plot_area,omitempty"`
	BuiltUpArea     float64   `json:"built_up_area,omitempty"`
	Views           []int64   `json:"views,omitempty"`
	Furnished       int64     `json:"furnished,omitempty"`
	StartDate       time.Time `json:"start_date,omitempty"`
	CompletionDate  time.Time `json:"completion_date,omitempty"`
	HandoverDate    time.Time `json:"handover_date,omitempty"`
	NoOfFloor       int64     `json:"no_of_floor,omitempty"`
	NoOfUnits       int64     `json:"no_of_units,omitempty"`
	MinArea         float64   `json:"min_area,omitempty"`
	MaxArea         float64   `json:"max_area,omitempty"`
	Parking         int64     `json:"parking,omitempty"`
	AskPrice        bool      `json:"ask_price,omitempty"`
	NoOfRetail      int64     `json:"no_of_retail,omitempty"`
	NoOfPool        int64     `json:"no_of_pool,omitempty"`
	Elevator        int64     `json:"elevator,omitempty"`
	StartingPrice   int64     `json:"starting_price,omitempty"`
	LifeStyle       int64     `json:"life_style,omitempty"`
	CommercialTax   float64   `json:"commercial_tax,omitempty"`
	MunicipalityTax float64   `json:"municipality_tax,omitempty"`
	UnitOfMeasure   string    `json:"unit_of_measure,omitempty"`
	//completion facts
	CompletionPercentage     float64   `json:"completion_percentage,omitempty"`
	CompletionPercentageDate time.Time `json:"completion_percentage_date,omitempty"`
	//property Details
	SectorNo   int64 `json:"sector_no,omitempty"`
	PlotNo     int64 `json:"plot_no,omitempty"`
	PropertyNo int64 `json:"property_no,omitempty"`
	// for versions
	Price            float64 `json:"price,omitempty"`
	RentType         int64   `json:"rent_type,omitempty"`
	NoOfPayment      int64   `json:"no_of_payment,omitempty"`
	CompletionStatus int64   `json:"completion_status,omitempty"`
	Ownership        int64   `json:"ownership,omitempty"`
	ServiceCharge    int64   `json:"service_charge,omitempty"`
	SCCurrencyID     int64   `json:"currency_id,omitempty"`
	// Details          DetailsObj `json:"details,omitempty"`
	// investment
	Investment pgtype.Bool `json:"investment,omitempty"`
	// InvestmentStateDate time.Time `json:"investment_state_date,omitempty"`
	// InvestmentEndDate   time.Time `json:"investment_end_date,omitempty"`
	// ROI
	IsROI          pgtype.Bool        `json:"roi,omitempty"`
	ROIStartDate   pgtype.Timestamptz `json:"roi_start_date,omitempty"`
	ROIEndDate     pgtype.Timestamptz `json:"roi_end_date,omitempty"`
	Amount         float64            `json:"amount,omitempty"`
	ContractAmount float64            `json:"contract_amount,omitempty"`
	// Exclusive
	IsExclusive        bool      `json:"exclusive,omitempty"`
	ExclusiveStateDate time.Time `json:"exclusive_state_date,omitempty"`
	ExclusiveEndDate   time.Time `json:"exclusive_end_date,omitempty"`
	BookNow            bool      `json:"book_now,omitempty"`
	BookingStateDate   time.Time `json:"book_now_start_date,omitempty"`
	BookingEndDate     time.Time `json:"book_now_end_date,omitempty"`
	ProjectName        string    `json:"project_name"`
	PhaseName          string    `json:"phase_name"`
}

// type DetailsObj struct {
// 	OwnerShip                any       `json:"owner_ship"`
// 	Lifestyle                any       `json:"lifestyle"`
// 	CompletionStatus         int64     `json:"completion_status"`
// 	CompletionDate           time.Time `json:"completion_date"`
// 	CompletionPercentage     float64   `json:"completion_percentage"`
// 	CompletionPercentageDate time.Time `json:"completion_percentage_date"`
// 	HandoverDate             time.Time `json:"handover_date"`
// 	StartDate                time.Time `json:"start_date"`
// }

type View struct {
	ID    int64  `json:"id"`
	Title string `json:"title"`
}

// default structure for unit facts
// {"rent":
// [{"id": 1, "icon": "dfsdfasd", "slug": "bedroom", "title": "Bedroom"},
// {"id": 2, "icon": "dfsdfasd", "slug": "bathroom", "title": "Bathroom"}],
// "sale": [{"id": 1, "icon": "dfsdfasd", "slug": "bedroom", "title": "Bedroom"},
// {"id": 2, "icon": "dfsdfasd", "slug": "bathroom", "title": "Bathroom"}], "swap": [{"id": 1, "icon": "dfsdfasd", "slug": "bathroom", "title": "Bathroom"}, {"id": 2, "icon": "dfsdfasd", "slug": "bathroom", "title": "Bathroom"}]}

type UnitTypeFact struct {
	ID   int    `json:"id"`
	Icon string `json:"icon"`
	// Slug  string `json:"slug"`
	Title string `json:"title"`
}

type UnitTypeFacts struct {
	Rent []UnitTypeFact `json:"rent"`
	Sale []UnitTypeFact `json:"sale"`
	// Swap []UnitTypeFact `json:"swap"`
}

func GetCategoryOrType(t int64) string {

	switch {
	case t == 1:
		return "Sale"
	case t == 2:
		return "Rent"
	default:
		return "Unknown"
	}

}

func GetSubscriptionString(s int64) string {

	switch {
	case s == 1:
		return "Top Deal"
	case s == 2:
		return "Premium"
	case s == 3:
		return "Featured"
	case s == 4:
		return "Standard"

	default:
		return "Unknown"
	}

}

func GetStatusInString(s int64) string {

	switch {
	case s == 1:
		return "Draft"
	case s == 2:
		return "Available"
	case s == 3:
		return "Sold"
	case s == 4:
		return "Rent"
	case s == 5:
		return "Blocked"
	case s == 6:
		return "Deleted"

	default:
		return "Unknown"
	}

}

func ConvertStringToPgTypeTimestamp(dateStr string) (pgtype.Timestamp, error) {
	// Parse the string date
	t, err := time.Parse("2006-01-02", dateStr)
	if err != nil {
		return pgtype.Timestamp{}, fmt.Errorf("failed to parse date: %v", err)
	}

	// Create pgtype.Timestamp
	pgTimestamp := pgtype.Timestamp{
		Time:  t,
		Valid: true,
	}

	return pgTimestamp, nil
}

func PrepareFullTextQuery(input string) string {
	// Remove special characters
	cleaned := specialCharsRegex.ReplaceAllString(input, "")

	// Replace multiple spaces with a single space
	cleaned = multiSpaceRegex.ReplaceAllString(cleaned, " ")

	// Trim leading and trailing spaces
	cleaned = strings.TrimSpace(cleaned)

	// Add :* to each word for prefix matching
	cleaned = wordRegex.ReplaceAllString(cleaned, "$1:*")

	// Replace spaces with & for AND logic
	cleaned = strings.ReplaceAll(cleaned, " ", " & ")

	return cleaned
}

func ExtractLatLng(fullURL string) (float64, float64, error) {

	// Regular expression to extract coordinates from the URL
	re := regexp.MustCompile(`@([0-9.-]+),([0-9.-]+),`)

	// Find matches
	matches := re.FindStringSubmatch(fullURL)

	if len(matches) < 3 {
		return 0, 0, fmt.Errorf("could not find coordinates in the page content")
	}

	lat, err := strconv.ParseFloat(string(matches[1]), 64)
	if err != nil {
		return 0, 0, fmt.Errorf("error parsing latitude: %v", err)
	}

	lng, err := strconv.ParseFloat(string(matches[2]), 64)
	if err != nil {
		return 0, 0, fmt.Errorf("error parsing longitude: %v", err)
	}

	return lat, lng, nil
}

type FileMetadata struct {
	OriginalFileName      string `json:"original_file_name"`
	OriginalFileExtension string `json:"original_file_extension"`
}

// Remove extension from file name return only file name
func RemoveExtension(fileName string) string {
	for i := len(fileName) - 1; i >= 0; i-- {
		if fileName[i] == '.' {
			return fileName[:i]
		}
	}
	return ""
}

// Remove path & extension, return only file name
func RemovePathAndExtension(path string) string {
	name := ExtractFileNameFromUrl(path)

	return RemoveExtension(name)
}

func CreateSlug(input string) string {
	// Normalize unicode and remove accents
	normalized := normalize(input)

	// Lowercase the string
	normalized = strings.ToLower(normalized)

	// Replace spaces and special characters with hyphens
	normalized = regexp.MustCompile(`[^a-z0-9\s-]`).ReplaceAllString(normalized, "")

	// Replace multiple spaces or hyphens with a single one
	normalized = regexp.MustCompile(`[\s-]+`).ReplaceAllString(normalized, "-")

	// Trim hyphens at the beginning or end
	normalized = strings.Trim(normalized, "-")

	// If the slug is empty after cleanup, return a default placeholder
	if normalized == "" {
		normalized = "default-slug"
	}

	return normalized
}

// normalize removes accents and normalizes unicode
func normalize(input string) string {
	// Create a runes.Set for non-spacing marks (accents) to be removed
	nonSpacingMarks := runes.In(unicode.Mn)

	// Normalize to NFD form and remove non-spacing marks (accents) using runes.Remove
	t := transform.Chain(norm.NFD, runes.Remove(nonSpacingMarks), norm.NFC)
	result, _, _ := transform.String(t, input)
	return result
}

// func CreateSlug(input string) string {
// 	// Trim spaces
// 	input = strings.TrimSpace(input)
// 	// Convert to lowercase
// 	input = strings.ToLower(input)
// 	// Replace spaces with hyphens
// 	input = strings.ReplaceAll(input, " ", "-")
// 	// Remove non-alphanumeric characters (except hyphens)
// 	re := regexp.MustCompile("[^a-z0-9-]")
// 	input = re.ReplaceAllString(input, "")
// 	return input
// }

func StoreHistory(ctx context.Context, history queue.History) error {
	log.Println("Storing history")
	redisClient, err := redis.NewRedisClient()
	if err != nil {
		log.Fatal("Failed to connect", zap.Error(err))
	}
	defer redisClient.Close()
	fmt.Println("history on store", history)
	err1 := redis.EnqueueHistory(ctx, redisClient, history)
	if err1 != nil {
		log.Fatal("Failed to enqueue history", zap.Error(err))
	}
	return nil
}

// CallHistoryAPI calls the History API with the given parameters and headers
func CallHistoryAPI(ctx *gin.Context, params map[string]string) (*[]queue.RespHistory, error) {
	// Define the API endpoint
	baseURL := config.AppConfig.HistoryAPIPath
	fmt.Println("0", baseURL)
	// Create the URL with query parameters
	reqURL, err := url.Parse(baseURL)
	if err != nil {
		return nil, fmt.Errorf("failed to parse base URL: %v", err)
	}
	fmt.Println("1", reqURL.String())
	query := reqURL.Query()
	for key, value := range params {
		query.Add(key, value)
	}
	reqURL.RawQuery = query.Encode()
	fmt.Println("2", reqURL.String())
	// Create the HTTP GET request
	req, err := http.NewRequest("GET", reqURL.String(), nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create HTTP request: %v", err)
	}
	fmt.Println("3", req)

	// Add headers
	req.Header.Set("X-API-Token", config.AppConfig.HistoryAPIToken)
	req.Header.Set("X-API-App", "aqary-backend")

	fmt.Println("4", req)
	// Send the request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("API request failed: %v", err)
	}
	defer resp.Body.Close()

	// Read the response body
	respBody, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response body: %v", err)
	}
	fmt.Println("response", respBody)

	// Handle non-200 status codes
	if resp.StatusCode < 200 || resp.StatusCode > 299 {
		return nil, fmt.Errorf("API returned status %d: %s", resp.StatusCode, string(respBody))
	}

	// Parse the response JSON into a map
	var result []queue.RespHistory
	err = json.Unmarshal(respBody, &result)
	if err != nil {
		return nil, fmt.Errorf("failed to parse response JSON: %v", err)
	}

	return &result, nil
}

type ImageTask struct {
	ID  int64    `json:"id"`
	Url []string `json:"url"`
}

func EnqueueForOptimization(task ImageTask) {
	redisClient, err := redis.NewRedisClient()
	if err != nil {
		log.Fatal("Failed to connect", zap.Error(err))
	}
	defer redisClient.Close()
	validForOptimization := []string{}
	for _, url := range task.Url {
		if IsOptimizationRequired(url) {
			validForOptimization = append(validForOptimization, url)
		}
	}

	task.Url = validForOptimization

	by, err := json.Marshal(task)
	if err != nil {
		log.Println("marshal error:", err)
		return
	}
	_, err = redisClient.SetRPushInFolder(context.Background(), "image-processing", "queue", by)
	if err != nil {
		log.Println("enqueue error:", err)
		return
	}
}
func IsOptimizationRequired(url string) bool {
	return filepath.Ext(url) != ".webp"
}

func CachePermissions(ctx context.Context, sectionPermissions []sqlc.SectionPermissionMv, permissions []sqlc.Permission, subSectionPermissions []sqlc.SubSection) bool {
	redisClient, err := redis.NewRedisClient()
	if err != nil {
		log.Fatal("Failed to connect", zap.Error(err))
	}
	defer redisClient.Close()

	// Drop all the index first so we don't get any error while creating again.
	redisClient.DropIndex("idx:permissions")
	redisClient.DropIndex("idx:sectionPermissions")
	redisClient.DropIndex("idx:subSectionPermissions")

	// section permissions indexing in cache
	schemaSectionPermission := redisearch.NewSchema(redisearch.DefaultOptions).
		AddField(redisearch.NewTextFieldOptions("$.title", redisearch.TextFieldOptions{Weight: 1.0, As: "title"})).
		AddField(redisearch.NewNumericFieldOptions("$.id", redisearch.NumericFieldOptions{As: "id"}))

	indexDefSectionPermission := redisearch.NewIndexDefinition().
		SetIndexOn(redisearch.JSON).
		AddPrefix("sectionPermissions")

	// permission indexing in cache
	schemaPermission := redisearch.NewSchema(redisearch.DefaultOptions).
		AddField(redisearch.NewTextFieldOptions("$.title", redisearch.TextFieldOptions{Weight: 1.0, As: "title"})).
		AddField(redisearch.NewNumericFieldOptions("$.section_permission_id", redisearch.NumericFieldOptions{As: "section_permission_id"})).
		AddField(redisearch.NewNumericFieldOptions("$.id", redisearch.NumericFieldOptions{As: "id"}))

	indexDefPermission := redisearch.NewIndexDefinition().
		SetIndexOn(redisearch.JSON).
		AddPrefix("permissions")

	// sub section permission indexing in cache
	schemaSubSectionPermission := redisearch.NewSchema(redisearch.DefaultOptions).
		AddField(redisearch.NewTextFieldOptions("$.sub_section_name", redisearch.TextFieldOptions{Weight: 1.0})).
		AddField(redisearch.NewNumericFieldOptions("$.id", redisearch.NumericFieldOptions{As: "id"})).
		AddField(redisearch.NewNumericFieldOptions("$.permissions_id", redisearch.NumericFieldOptions{As: "permissions_id"})).
		AddField(redisearch.NewNumericFieldOptions("$.sub_section_button_id", redisearch.NumericFieldOptions{As: "sub_section_button_id"}))

	indexDefSubSectionPermission := redisearch.NewIndexDefinition().
		SetIndexOn(redisearch.JSON).
		AddPrefix("subSectionPermissions")

	sectionPermissionCached(ctx, redisClient, sectionPermissions)
	permissionsCached(ctx, redisClient, permissions)
	subSectionpermissionsCached(ctx, redisClient, subSectionPermissions)

	redisClient.CreateSectionPermissionIndexClient(schemaSectionPermission, indexDefSectionPermission)
	redisClient.CreatePermissionIndexClient(schemaPermission, indexDefPermission)
	redisClient.CreateSubSectionPermissionIndexClient(schemaSubSectionPermission, indexDefSubSectionPermission)

	return true
}

func sectionPermissionCached(ctx context.Context, redis *queue.RedisClient, sectionPermissions []sqlc.SectionPermissionMv) bool {
	//cache the section permissions
	for _, section := range sectionPermissions {
		newKey := SECTION_PERMISSION_CACHE_KEY + strconv.Itoa(int(section.ID))
		data, err := marshalSectionPermissions(section)
		if err != nil {
			fmt.Println("error marshalling section permissions")
		}
		err1 := redis.SetJSON(ctx, newKey, data, time.Hour*3600)
		if err1 != nil {
			fmt.Println("error cache section permissions", err1)
		}
	}
	return true
}
func permissionsCached(ctx context.Context, redis *queue.RedisClient, permissions []sqlc.Permission) bool {
	//cache the section permissions
	for _, permission := range permissions {
		newKey := PERMISSION_CACHE_KEY + strconv.Itoa(int(permission.ID))
		data, err := marshalPermissions(permission)
		if err != nil {
			fmt.Println("error marshalling permissions")
		}

		err1 := redis.SetJSON(ctx, newKey, data, time.Hour*3600)
		if err1 != nil {
			fmt.Println("error marshalling permissions", err1)
		}
	}
	return true
}

func subSectionpermissionsCached(ctx context.Context, redis *queue.RedisClient, permissions []sqlc.SubSection) bool {
	//cache the section permissions
	for _, permission := range permissions {
		newKey := SUB_SECTION_PERMISSION_CACHE_KEY + strconv.Itoa(int(permission.ID))
		data, err := marshalSubSectionPermissions(permission)
		if err != nil {
			fmt.Println("error marshalling sub section permissions")
		}

		err1 := redis.SetJSON(ctx, newKey, data, time.Hour*3600)
		if err1 != nil {
			fmt.Println("error marshalling sub section permissions", err1)
		}
	}
	return true
}

// Helper function to marshal permissions data to a string (or JSON, depending on your data format)
func marshalSectionPermissions(sectionPermissions sqlc.SectionPermissionMv) ([]byte, error) {
	// Assuming you're using JSON
	jsonData, err := json.Marshal(sectionPermissions)
	if err != nil {
		return nil, fmt.Errorf("error marshaling section permission data: %v", err)
	}
	return jsonData, nil
}

func marshalPermissions(permission sqlc.Permission) ([]byte, error) {
	// Assuming you're using JSON
	jsonData, err := json.Marshal(permission)
	if err != nil {
		return nil, fmt.Errorf("error marshaling permissions data: %v", err)
	}
	return jsonData, nil
}

func marshalSubSectionPermissions(permission sqlc.SubSection) ([]byte, error) {
	// Assuming you're using JSON
	jsonData, err := json.Marshal(permission)
	if err != nil {
		return nil, fmt.Errorf("error marshaling sub section permission data: %v", err)
	}
	return jsonData, nil
}

func GetAllFactsDetails(store sqlc.Querier) ([]sqlc.Fact, *exceptions.Exception) {

	rdb, err := redis.NewRedisClient()

	var facts []sqlc.Fact

	//check for errors
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while retrieving facts details, redis client")
	}
	defer rdb.Close()

	// Create a context
	ctx := context.Background()

	// the key to retrieve facts details that are stored in Redis.
	key := "All-Facts"

	// try to retrieve by key
	value, err_rdb := rdb.GetJSONFromFolder(ctx, "facts", key)

	// if both value and error are nil, Redis has no data for this key.
	if len(value) == 0 || value == nil || err_rdb != nil {

		if err_rdb != nil {
			fmt.Printf("error has been occured while getting facts from cache : %d", err_rdb)
		}

		// retrieve the facts details from the database if Redis has no data for this key.
		all_facts_details, err := store.GetAllFactsDetails(ctx)

		//check for errors
		if err != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while retrieving facts details, db")
		}

		// marshal the facts details into bytes for storage
		all_facts_details_bytes, err := json.Marshal(all_facts_details)

		//check for errors
		if err != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while retrieving facts details,marshal")
		}

		// store the facts details in Redis
		err = rdb.SetJSONInFolder(ctx, "facts", key, all_facts_details_bytes, 30*24*time.Hour)

		//check for errors
		if err != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while retrieving facts details, set json folder")
		}

		// facts will be the final response
		facts = all_facts_details
	} else {

		// if facts details are stored in Redis, unmarshal them and send the response.
		err := json.Unmarshal(value, &facts)

		if err != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while retrieving facts details, unmarshal")
		}

	}

	return facts, nil
}

func MapAndUpdateFacts(existing Facts, updated Facts) Facts {
	if updated.Bedroom != "" {
		existing.Bedroom = updated.Bedroom
	}
	if updated.Bathroom != 0 {
		existing.Bathroom = updated.Bathroom
	}
	if updated.PlotArea != 0 {
		existing.PlotArea = updated.PlotArea
	}
	if updated.BuiltUpArea != 0 {
		existing.BuiltUpArea = updated.BuiltUpArea
	}
	if len(updated.Views) > 0 {
		existing.Views = updated.Views
	}
	if updated.Furnished != 0 {
		existing.Furnished = updated.Furnished
	}
	if !updated.StartDate.IsZero() {
		existing.StartDate = updated.StartDate
	}
	if !updated.CompletionDate.IsZero() {
		existing.CompletionDate = updated.CompletionDate
	}
	if !updated.HandoverDate.IsZero() {
		existing.HandoverDate = updated.HandoverDate
	}
	if updated.NoOfFloor != 0 {
		existing.NoOfFloor = updated.NoOfFloor
	}
	if updated.NoOfUnits != 0 {
		existing.NoOfUnits = updated.NoOfUnits
	}
	if updated.MinArea != 0 {
		existing.MinArea = updated.MinArea
	}
	if updated.MaxArea != 0 {
		existing.MaxArea = updated.MaxArea
	}
	if updated.Parking != 0 {
		existing.Parking = updated.Parking
	}
	if updated.AskPrice {
		existing.AskPrice = updated.AskPrice
	}
	if updated.NoOfRetail != 0 {
		existing.NoOfRetail = updated.NoOfRetail
	}
	if updated.NoOfPool != 0 {
		existing.NoOfPool = updated.NoOfPool
	}
	if updated.Elevator != 0 {
		existing.Elevator = updated.Elevator
	}
	if updated.StartingPrice != 0 {
		existing.StartingPrice = updated.StartingPrice
	}
	if updated.LifeStyle != 0 {
		existing.LifeStyle = updated.LifeStyle
	}
	if updated.CommercialTax != 0 {
		existing.CommercialTax = updated.CommercialTax
	}
	if updated.MunicipalityTax != 0 {
		existing.MunicipalityTax = updated.MunicipalityTax
	}
	if updated.UnitOfMeasure != "" {
		existing.UnitOfMeasure = updated.UnitOfMeasure
	}
	if updated.CompletionPercentage != 0 {
		existing.CompletionPercentage = updated.CompletionPercentage
	}
	if !updated.CompletionPercentageDate.IsZero() {
		existing.CompletionPercentageDate = updated.CompletionPercentageDate
	}
	if updated.SectorNo != 0 {
		existing.SectorNo = updated.SectorNo
	}
	if updated.PlotNo != 0 {
		existing.PlotNo = updated.PlotNo
	}
	if updated.PropertyNo != 0 {
		existing.PropertyNo = updated.PropertyNo
	}
	if updated.Price != 0 {
		existing.Price = updated.Price
	}
	if updated.RentType != 0 {
		existing.RentType = updated.RentType
	}
	if updated.NoOfPayment != 0 {
		existing.NoOfPayment = updated.NoOfPayment
	}
	if updated.CompletionStatus != 0 {
		existing.CompletionStatus = updated.CompletionStatus
	}
	if updated.Ownership != 0 {
		existing.Ownership = updated.Ownership
	}
	if updated.ServiceCharge != 0 {
		existing.ServiceCharge = updated.ServiceCharge
	}
	if updated.SCCurrencyID != 0 {
		existing.SCCurrencyID = updated.SCCurrencyID
	}
	if updated.Investment.Bool {
		existing.Investment = updated.Investment
	}
	if updated.IsROI.Bool {
		existing.IsROI = updated.IsROI
	}
	if updated.ROIStartDate.Valid {
		existing.ROIStartDate = updated.ROIStartDate
	}
	if updated.ROIEndDate.Valid {
		existing.ROIEndDate = updated.ROIEndDate
	}
	if updated.Amount != 0 {
		existing.Amount = updated.Amount
	}
	if updated.IsExclusive {
		existing.IsExclusive = updated.IsExclusive
	}
	if !updated.ExclusiveStateDate.IsZero() {
		existing.ExclusiveStateDate = updated.ExclusiveStateDate
	}
	if !updated.ExclusiveEndDate.IsZero() {
		existing.ExclusiveEndDate = updated.ExclusiveEndDate
	}
	if updated.BookNow {
		existing.BookNow = updated.BookNow
	}
	if !updated.BookingStateDate.IsZero() {
		existing.BookingStateDate = updated.BookingStateDate
	}
	if !updated.BookingEndDate.IsZero() {
		existing.BookingEndDate = updated.BookingEndDate
	}
	if updated.ProjectName != "" {
		existing.ProjectName = updated.ProjectName
	}
	if updated.PhaseName != "" {
		existing.PhaseName = updated.PhaseName
	}
	return existing
}

func ProcessRequestCameFromQueue(request_id int64, step int64, q sqlc.Querier) *exceptions.Exception {

	err := q.CreatePendingApproval(context.Background(), sqlc.CreatePendingApprovalParams{
		Remarks:       "",
		PendingStatus: constants.ApprovalStatus.ConstantId("Pending"),
		RequestID:     request_id,
		WorkflowStep:  step,
	})

	if err != nil {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while creating the request with a pending status")
	}
	return nil
}

func CreateRedisQueryForPermissionIds(permissionsIDs []int64) string {
	// Start with the section_permission_id filter, if any.
	parts := []string{}

	for _, id := range permissionsIDs {
		// Convert each int64 to string and wrap it in [id id] for the query
		parts = append(parts, fmt.Sprintf("@id:[%d %d]", id, id))
	}

	// Join the parts with | (OR operator)
	query := fmt.Sprintf("(%s)", strings.Join(parts, " | "))
	return query
}

func CreateRedisQueryForSubSectionIds(subsectionIds []int64) string {
	// Start with the section_permission_id filter, if any.
	parts := []string{}

	for _, id := range subsectionIds {
		// Convert each int64 to string and wrap it in [id id] for the query
		parts = append(parts, fmt.Sprintf("@id:[%d %d]", id, id))
	}

	// Join the parts with | (OR operator)
	query := fmt.Sprintf("(%s)", strings.Join(parts, " | "))
	return query
}

func Contains(slice []int64, id int64) bool {
	for _, v := range slice {
		if v == id {
			return true
		}
	}
	return false
}

func SplitAndParsePhoneNumber(phoneNumberWithCode string) (code int64, phone int64) {
	phoneWithCode := strings.Split(phoneNumberWithCode, "-")
	if len(phoneWithCode) != 2 {
		return 0, 0
	}

	c := strings.Trim(phoneWithCode[0], " ")
	p := strings.Trim(phoneWithCode[1], " ")

	// Validate numeric values (ignoring '-')
	if !isNumeric(c) || !isNumeric(p) {
		return 0, 0
	}

	co, _ := strconv.Atoi(c)
	ph, _ := strconv.Atoi(p)

	return int64(co), int64(ph)
}

func isNumeric(s string) bool {
	for _, char := range s {
		if !unicode.IsDigit(char) {
			return false
		}
	}
	return true
}

func DeleteJSONFromFolder(ctx context.Context, folder string, key string) {
	redisClient, er := redis.NewRedisClient()
	if er != nil {
		log.Fatal("Failed to connect", zap.Error(er))
	}
	defer redisClient.Close()

	redisClient.DeleteJSONFromFolder(ctx, folder, key)
}

func MergeUnique(slices ...[]int64) []int64 {
	resultMap := make(map[int64]struct{})

	// Loop through each slice
	for _, slice := range slices {
		for _, id := range slice {
			resultMap[id] = struct{}{} // Using an empty struct as a value, since we only care about the keys
		}
	}

	// Convert the map keys back to a slice
	var result []int64
	for id := range resultMap {
		result = append(result, id)
	}

	return result
}

func CachePurgeAll(ctx context.Context) bool {
	redisClient, err := redis.NewRedisClient()
	if err != nil {
		log.Fatal("Failed to connect", zap.Error(err))
	}
	defer redisClient.Close()

	redisClient.FlushAll(ctx)

	return true
}

// work only for comparable types
func RemoveItem[T comparable](slice []T, element T) []T {
	for index, e := range slice {
		if e == element {
			slice = append(slice[:index], slice[index+1:]...)
			return slice
		}
	}
	return slice
}

func GenerateOTP() int {
	// Seed the random number generator
	rand.Seed(uint64(time.Now().UnixNano())) // Convert int64 to uint64

	// Generate a random number between 100000 and 999999 (inclusive)
	otp := rand.Intn(900000) + 100000

	// Return the OTP as a string
	return otp
}

func PByte(scaryByte []byte) {
	// Use a buffer to pretty-print
	var prettyJSON bytes.Buffer
	errr := json.Indent(&prettyJSON, scaryByte, "", "  ")
	if errr != nil {
		fmt.Println("Error formatting JSON:", errr)
	}

	fmt.Println("Pretty JSON:")
	fmt.Println(prettyJSON.String())
}
