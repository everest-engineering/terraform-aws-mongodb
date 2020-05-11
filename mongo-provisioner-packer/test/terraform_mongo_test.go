package test

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

func TestTerraformAwsExample(t *testing.T) {
	t.Parallel()
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples",
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	mongodbConnectURL := terraform.Output(t, terraformOptions, "mongo_connect_url")
	fmt.Println("mongodbConnectUrl: ", mongodbConnectURL)
	client, err := mongo.NewClient(options.Client().ApplyURI(mongodbConnectURL))
	assert.Nil(t, err)

	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	err = client.Connect(ctx)
	assert.Nil(t, err)

	ctx, _ = context.WithTimeout(context.Background(), 2*time.Second)
	err = client.Ping(ctx, readpref.Primary())
	assert.Nil(t, err)
}
