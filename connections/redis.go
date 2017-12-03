package connections

import (
	"os"
	"time"

	"github.com/garyburd/redigo/redis"
	log "github.com/meifamily/logrus"
)

var pool = newPool()

func newPool() *redis.Pool {
	return &redis.Pool{
		MaxIdle:     3,
		IdleTimeout: 300 * time.Second,
		Dial: func() (redis.Conn, error) {
			conn, err := redis.Dial("tcp", os.Getenv("Redis-EndPoint")+":"+os.Getenv("Redis-Port"))
			if err != nil {
				log.Fatal(err)
			}
			return conn, err
		},
	}
}

// Redis get redis connection
func Redis() redis.Conn {
	return pool.Get()
}
