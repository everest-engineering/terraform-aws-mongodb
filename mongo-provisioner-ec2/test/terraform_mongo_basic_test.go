package test

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
    "go.mongodb.org/mongo-driver/mongo/readpref"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsExample(t *testing.T) {
	t.Parallel()
    terraformOptions := &terraform.Options{
    		// The path to where our Terraform code is located
    		TerraformDir: "../examples/standalone-mongodb-ec2",
    }
    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)
    mongodbConnectUrl := terraform.Output(t, terraformOptions, "mongo_connect_url")
    fmt.Println("mongodbConnectUrl: ", mongodbConnectUrl)
    client, err := mongo.NewClient(options.Client().ApplyURI(mongodbConnectUrl))
    assert.Nil(t, err)

    ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
    err = client.Connect(ctx)
    assert.Nil(t, err)

    ctx, _ = context.WithTimeout(context.Background(), 2*time.Second)
    err = client.Ping(ctx, readpref.Primary())
    assert.Nil(t, err)
}