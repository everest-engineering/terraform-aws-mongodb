package test

import (
	"context"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
	"testing"
	"time"
)

var region string
var name string

func TestTerraformExample(t *testing.T) {
	t.Parallel()
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/",
	}
	defer deleteEBSVolume(t)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	publicIp := terraform.Output(t, terraformOptions, "public_ip")
	region = terraform.Output(t, terraformOptions, "cluster_region")
	name = terraform.Output(t, terraformOptions, "cluster_name")
	connectionString := "mongodb://" + publicIp + ":27017"
	ctx, _ := context.WithTimeout(context.Background(), 30*time.Second)
	client, err := mongo.Connect(ctx,
		options.Client().ApplyURI(connectionString), options.Client().SetServerSelectionTimeout(30*time.Second))
	assert.Nil(t, err)

	ctx, _ = context.WithTimeout(context.Background(), 1*time.Minute)
	err = client.Ping(ctx, readpref.Primary())
	assert.Nil(t, err)
}

//Delete volume provisioned by rexray/ebs plugin
func deleteEBSVolume(t *testing.T) {
	newSession, _ := session.NewSession(&aws.Config{
		Region: aws.String(region),
	})
	ec2Service := ec2.New(newSession)
	input := &ec2.DescribeVolumesInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("tag:Name"),
				Values: []*string{
					aws.String(name),
				},
			},
		},
	}
	data, err := ec2Service.DescribeVolumes(input)
	assert.Nil(t, err)
	assert.True(t, len(data.Volumes) <= 1, "Found multiple test volumes with same name")
	if len(data.Volumes) == 1 {
		deleteVolumeInput := &ec2.DeleteVolumeInput{
			VolumeId: data.Volumes[0].VolumeId,
		}
		_, err = ec2Service.DeleteVolume(deleteVolumeInput)
		assert.Nil(t, err)
	}
}
