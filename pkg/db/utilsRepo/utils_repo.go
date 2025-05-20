package db

import (
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	multipart "mime/multipart"
	// "github.com/jackc/pgx/v5/pgtype"
	file_utils "aqary_admin/pkg/utils/file"

	// utils "aqary_admin/pkg/utils"
	"github.com/gin-gonic/gin"
)

type UtilsRepository interface {
	UploadMultipleFileToABS(fileHeader []*multipart.FileHeader, kPath string) ([]string, *exceptions.Exception)
	UploadSingleFileToABS(c *gin.Context, fileHeader *multipart.FileHeader, kPath string) (string, *exceptions.Exception)
	MultipartForm(c *gin.Context) (*multipart.Form, *exceptions.Exception)
	DeleteMultipleFilesFromABS(fileNames []string) *exceptions.Exception
	FormFile(c *gin.Context, name string) (*multipart.FileHeader, *exceptions.Exception)
}

type UtilsRepo struct {
}

func (u *UtilsRepo) FormFile(c *gin.Context, name string) (*multipart.FileHeader, *exceptions.Exception) {
	file, err := c.FormFile(name)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return file, nil
}

func NewUtilsRepository() UtilsRepository {
	return &UtilsRepo{}
}

func (u *UtilsRepo) DeleteMultipleFilesFromABS(fileNames []string) *exceptions.Exception {

	err_delete_multiple_files := utils.DeleteMultipleFilesFromABS(fileNames)

	if err_delete_multiple_files != nil {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "encountered an issue while trying to delete all files")
	}

	return nil
}

func (u *UtilsRepo) UploadMultipleFileToABS(fileHeader []*multipart.FileHeader, kPath string) ([]string, *exceptions.Exception) {

	files, err := utils.UploadMultipleFileToABS(fileHeader, kPath)

	if err != nil {
		return nil, exceptions.GetExceptionByErrorCode(exceptions.ErrorCode(err.Error()))
	}

	return files, nil
}
func (u *UtilsRepo) MultipartForm(c *gin.Context) (*multipart.Form, *exceptions.Exception) {
	form, err := c.MultipartForm()
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCode(exceptions.ErrorCode(err.Error()))
	}
	return form, nil
}

// UploadSingleFileToABS implements ExhibitionRepo.
func (u *UtilsRepo) UploadSingleFileToABS(c *gin.Context, fileHeader *multipart.FileHeader, kPath string) (string, *exceptions.Exception) {
	file, err := file_utils.UploadSingleFileToABS(c, fileHeader, kPath)
	if err != nil {
		return "", exceptions.GetExceptionByErrorCode(exceptions.ErrorCode(err.Error()))
	}
	return file, nil
}
