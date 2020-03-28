# opencv2-lambda-layer
A AWS Lambda layer for OpenCV2. Build it yourself and publish it to your private AWS account.

## Building
For building the OpenCV2 lambda layer, you will need working installations of Docker and Serverless.

### Layer content creation
You can run `./build.sh` in the root directory of this repository to create the layer content and deploy it to your AWS account.

## Usage

### Using the layer
You can now use the stack output `OpenCV2Python37LambdaLayer` in other stacks to reference the newly created Tile38 Lambda layer.

For example, if you use Serverless, you can reference if via 

```yaml
functions:
  myfunction:
    ...
    layers:
      - ${cf:opencv2-lambda-layer-dev.OpenCV2Python37LambdaLayer}
```

Note that the `dev` in the variable above is the stage of your layer service.
