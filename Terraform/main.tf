provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "my_app_repo" {
  name = "my-app-repo"
}

resource "aws_ecs_task_definition" "my_app_task" {
  family                   = "my-app-task"
  container_definitions    = jsonencode([{
    name      = "my-app-container"
    image     = "public.ecr.aws/i2h8c8g9/joel:latest"
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "my_app_service" {
  name            = "my-app-service"
  cluster         = "default"
  task_definition = "${aws_ecs_task_definition.my_app_task.arn}"
  desired_count   = 1

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets          = ["<SUBNET_ID_1>", "<SUBNET_ID_2>"]
    security_groups  = ["<SECURITY_GROUP_ID>"]
    assign_public_ip = true
  }
}
