# Packer AMI

Building the custom AMI images for mongodb for various cloud platforms and also for various linux distributions.

### Tech
* [Packer] - Packer is a free and open source tool for creating golden images for multiple platforms from a single source configuration.
* [Shell] - A script to provision mongo distribution on AMI image.

### Installation
Install packer using below documentation

```https://www.packer.io/intro/getting-started/```

### Configuration

You can pass custom configuration to ``template.json`` before you build the image.

* `` base_ami: `` Base ami id on which it will provision the mongo db. ```Ex: ami-0fd7e4b8e94538bef```
* `` region: ``  In which region to upload this custom image. ```Ex: ap-south-1```
* `` mongo_version: `` Version of mongo db. ``` Ex: 4.2```
* `` ami_version: `` Tag the version to custom ami. ```Ex: v1.0```

### To build image

Before we take this template and build an image from it, let's validate the template by running 

```sh 
$ packer validate template.json
```
Before you build the image on cloud platforms, you need to setup authentication. To setup authentication follow below documentation
   
   ``` https://www.packer.io/docs/builders/amazon/#authentication ```

Building custom images on AWS:
```sh
$ cd Packer-AMI
$ packer build template.json -var region=ap-south-1 -var ami_version=v1.0 -var mongo_version=4.2 -var base_ami=ami-0fd7e4b8e94538bef
```
Once you have done above steps, it will produce the AMI image with below name ```ubuntu-18.04_mongodb-4.2_v1.0 ```

```Note```: If you dont specify any configuration, it will take default configuration.

### Build Images in CI/CD

To automate the process of building images in CI/CD you can follow the below documentation:

```https://www.packer.io/guides/packer-on-cicd/build-image-in-cicd/```

You can import the ```Jenkinsfile``` to automate the CI/CD using jenkins.

### Deployment

As packer is tool for creating custom images, they don't have any deployment options. You can use your own deployment options using CI/CD.

Refer the below documentation to upload your artifacts to cloud:

``` https://www.packer.io/docs/templates/post-processors/ ```


