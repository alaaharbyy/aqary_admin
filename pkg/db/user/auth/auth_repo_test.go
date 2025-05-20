package auth_repo_test

import (
	"errors"
	"fmt"
	"log"
	"testing"
	"time"

	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"

	db "aqary_admin/pkg/db/user/auth"
	"aqary_admin/pkg/utils"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestAuthRepository(t *testing.T) {
	utils.IS_TEST_MODE = true
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewAuthRepository(mockQuerier)

	t.Run("GetCountryByName", func(t *testing.T) {
		c := &gin.Context{}
		countryName := "test_country"
		expectedCountry := sqlc.Country{ID: 1, Country: countryName}

		t.Run("When country is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountryByName(c, countryName).Return(expectedCountry, nil)
			country, err := repo.GetCountryByName(c, countryName)
			assert.NoError(t, err)
			assert.Equal(t, &expectedCountry, country)
		})

		t.Run("When country is not found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountryByName(c, countryName).Return(sqlc.Country{}, pgx.ErrNoRows)
			_, err := repo.GetCountryByName(c, countryName)
			assert.Error(t, err)
			assert.EqualError(t, err, "no country found")
		})

		t.Run("When other error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetCountryByName(c, countryName).Return(sqlc.Country{}, expectedError)
			_, err := repo.GetCountryByName(c, countryName)
			assert.Error(t, err)
			assert.Equal(t, expectedError, err)
		})
	})

	t.Run("CreateCountry", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.CreateCountryParams{Country: "test_country"}
		expectedCountry := sqlc.Country{ID: 1, Country: args.Country}

		t.Run("When country is created successfully", func(t *testing.T) {
			mockQuerier.EXPECT().CreateCountry(c, args).Return(expectedCountry, nil)
			country, err := repo.CreateCountry(c, args, mockQuerier)
			assert.NoError(t, err)
			assert.Equal(t, &expectedCountry, country)
		})

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().CreateCountry(c, args).Return(sqlc.Country{}, expectedError)
			_, err := repo.CreateCountry(c, args, mockQuerier)
			assert.Error(t, err)
			assert.Equal(t, expectedError, err)
		})
	})

	t.Run("GetSuperUser", func(t *testing.T) {
		c := &gin.Context{}
		expectedSuperUser := sqlc.User{ID: 1, Username: "super_user"}

		t.Run("When super user is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetSuperUser(c).Return(expectedSuperUser, nil)
			superUser, err := repo.GetSuperUser(c)
			assert.NoError(t, err)
			assert.Equal(t, &expectedSuperUser, superUser)
		})

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetSuperUser(c).Return(sqlc.User{}, expectedError)
			_, err := repo.GetSuperUser(c)
			assert.Error(t, err)
			assert.Equal(t, expectedError, err)
		})
	})

	t.Run("GetLanguageByLanguage", func(t *testing.T) {
		c := &gin.Context{}
		language := "en"
		expectedLanguage := sqlc.AllLanguage{ID: 1, Language: language}

		t.Run("When language is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetLanguageByLanguage(c, language).Return(expectedLanguage, nil)
			lang, err := repo.GetLanguageByLanguage(c, language)
			assert.NoError(t, err)
			assert.Equal(t, &expectedLanguage, lang)
		})

		t.Run("When language is not found", func(t *testing.T) {
			mockQuerier.EXPECT().GetLanguageByLanguage(c, language).Return(sqlc.AllLanguage{}, pgx.ErrNoRows)
			_, err := repo.GetLanguageByLanguage(c, language)
			assert.Error(t, err)
			assert.EqualError(t, err, "not language found")
		})

		t.Run("When other error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetLanguageByLanguage(c, language).Return(sqlc.AllLanguage{}, expectedError)
			_, err := repo.GetLanguageByLanguage(c, language)
			assert.Error(t, err)
			assert.Equal(t, expectedError, err)
		})
	})

	t.Run("CreateLanguage", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.CreateLanguageParams{Language: "en"}
		expectedLanguage := sqlc.AllLanguage{ID: 1, Language: args.Language}

		t.Run("When language is created successfully", func(t *testing.T) {
			mockQuerier.EXPECT().CreateLanguage(c, args).Return(expectedLanguage, nil)
			language, err := repo.CreateLanguage(c, args, mockQuerier)
			assert.NoError(t, err)
			assert.Equal(t, &expectedLanguage, language)
		})

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().CreateLanguage(c, args).Return(sqlc.AllLanguage{}, expectedError)
			_, err := repo.CreateLanguage(c, args, mockQuerier)
			assert.Error(t, err)
			assert.Equal(t, expectedError, err)
		})
	})

	t.Run("GetCompanySectionPermission", func(t *testing.T) {
		c := &gin.Context{}
		expectedSectionPermission := sqlc.SectionPermission{ID: 1, Title: "test_section_permission"}

		t.Run("When section permission is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanySectionPermission(c).Return(expectedSectionPermission, nil)
			sectionPermission, err := repo.GetCompanySectionPermission(c)
			assert.NoError(t, err)
			assert.Equal(t, &expectedSectionPermission, sectionPermission)
		})

		t.Run("When section permission is not found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanySectionPermission(c).Return(sqlc.SectionPermission{}, pgx.ErrNoRows)
			_, err := repo.GetCompanySectionPermission(c)
			assert.Error(t, err)
			assert.EqualError(t, err, "no company section permission available")
		})

		t.Run("When other error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetCompanySectionPermission(c).Return(sqlc.SectionPermission{}, expectedError)
			_, err := repo.GetCompanySectionPermission(c)
			assert.Error(t, err)
			assert.Equal(t, expectedError, err)
		})
	})

	t.Run("GetAddCompanyPermission", func(t *testing.T) {
		c := &gin.Context{}
		expectedPermission := sqlc.Permission{ID: 1, Title: "add_company"}

		t.Run("When permission is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetAddCompanyPermission(c).Return(expectedPermission, nil)
			permission, err := repo.GetAddCompanyPermission(c)
			assert.NoError(t, err)
			assert.Equal(t, &expectedPermission, permission)
		})

		t.Run("When permission is not found", func(t *testing.T) {
			mockQuerier.EXPECT().GetAddCompanyPermission(c).Return(sqlc.Permission{}, pgx.ErrNoRows)
			_, err := repo.GetAddCompanyPermission(c)
			assert.Error(t, err)
			assert.EqualError(t, err, "no company permission found")
		})

		t.Run("When other error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetAddCompanyPermission(c).Return(sqlc.Permission{}, expectedError)
			_, err := repo.GetAddCompanyPermission(c)
			assert.Error(t, err)
			assert.EqualError(t, err, fmt.Errorf("error while getting company permission:%v", expectedError).Error())
		})
	})

	t.Run("GetPermissionMV", func(t *testing.T) {
		c := &gin.Context{}
		permissionMVID := int64(1)
		expectedPermissionMV := sqlc.PermissionsMv{ID: permissionMVID, Title: "test_permission_mv"}

		t.Run("When permissions MV is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetPermissionMV(c, permissionMVID).Return(expectedPermissionMV, nil)
			permissionMV, err := repo.GetPermissionMV(c, permissionMVID)
			assert.NoError(t, err)
			assert.Equal(t, &expectedPermissionMV, permissionMV)
		})

		t.Run("When permissions MV is not found", func(t *testing.T) {
			mockQuerier.EXPECT().GetPermissionMV(c, permissionMVID).Return(sqlc.PermissionsMv{}, pgx.ErrNoRows)
			_, err := repo.GetPermissionMV(c, permissionMVID)
			assert.Error(t, err)
			assert.EqualError(t, err, "no permisison mv found")
		})

		t.Run("When other error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetPermissionMV(c, permissionMVID).Return(sqlc.PermissionsMv{}, expectedError)
			_, err := repo.GetPermissionMV(c, permissionMVID)
			assert.Error(t, err)
			assert.Equal(t, expectedError, err)
		})
	})

	t.Run("GetSectionPermissionMV", func(t *testing.T) {
		c := &gin.Context{}
		ID := int64(1)
		expectedPermission := sqlc.SectionPermissionMv{
			ID:        ID,
			Title:     "testing title",
			SubTitle:  pgtype.Text{},
			Indicator: 0,
			CreatedAt: time.Time{},
			UpdatedAt: time.Time{},
		}

		t.Run("When permission is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetSectionPermissionMV(c, ID).Return(expectedPermission, nil)
			permission, err := repo.GetSectionPermissionMV(c, ID)
			assert.Nil(t, err)
			assert.Equal(t, &expectedPermission, permission)
		})

		t.Run("When permission is Not found", func(t *testing.T) {
			mockQuerier.EXPECT().GetSectionPermissionMV(c, ID).Return(sqlc.SectionPermissionMv{}, errors.New("no rows in result set"))
			_, err := repo.GetSectionPermissionMV(c, ID)
			log.Println("testing err", err)
			assert.NotNil(t, err)
			// assert.Equal(t, &expectedPermission, permission)
		})

	})

}
