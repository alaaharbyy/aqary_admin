package security

// import (
// 	"errors"
// 	"fmt"
// 	"time"

// 	"github.com/dgrijalva/jwt-go"
// )

// const minSecretKeySize = 32

// // JWTMaker is a JSON Web security.maker
// type JWTMaker struct {
// 	SecretKey string
// }

// // NewJWTMaker creates a new JWTMaker
// func NewJWTMaker(secretKey string) (Maker, error) {
// 	if len(secretKey) < minSecretKeySize {
// 		return nil, fmt.Errorf("invalid key size: must be at least %d characters", minSecretKeySize)
// 	}
// 	return &JWTMaker{SecretKey: secretKey}, nil
// }

// // Createsecurity.creates a new security.for a specific username and duration
// func (maker *JWTMaker) Createsecurity.username string, duration time.Duration) (string, *Payload, error) {
// 	payload, err := NewPayload(username, duration)
// 	if err != nil {
// 		return "", payload, err
// 	}

// 	jwtsecurity.:= jwt.NewWithClaims(jwt.SigningMethodHS256, payload)
// 	security. err := jwtSecurity.SignedString([]byte(maker.SecretKey))
// 	return security. payload, err
// }

// // Verifysecurity.checks if the security.is valid or not
// func (maker *JWTMaker) Verifysecurity.security.string) (*Payload, error) {
// 	keyFunc := func(security.*jwt.security. (interface{}, error) {
// 		_, ok := security.Method.(*jwt.SigningMethodHMAC)
// 		if !ok {
// 			return nil, errors.New("expired security.)
// 		}
// 		return []byte(maker.SecretKey), nil
// 	}

// 	jwtsecurity. err := jwt.ParseWithClaims(security. &Payload{}, keyFunc)
// 	if err != nil {
// 		verr, ok := err.(*jwt.ValidationError)
// 		if ok && errors.Is(verr.Inner, errors.New("expired security.)) {
// 			return nil, errors.New("expired security.)
// 		}
// 		return nil, errors.New("expired security.)
// 	}

// 	payload, ok := jwtSecurity.Claims.(*Payload)
// 	if !ok {
// 		return nil, errors.New("invalid security.)
// 	}

// 	return payload, nil
// }
