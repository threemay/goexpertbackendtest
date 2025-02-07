provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_ecs_cluster" "example" {
  name = "mytestshuo-cluster"
}

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecsTaskExecutionRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

resource "aws_ecs_task_definition" "example" {
  family                   = "example-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = "arn:aws:iam::586520679870:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::586520679870:role/ecsTaskRole"
  container_definitions = jsonencode([
    {
      name   = "mongodb"
      image  = "mongo:latest"
      cpu    = 256
      memory = 512
      portMappings = [
        {
          name          = "mongodb-27017-tcp"
          containerPort = 27017
          hostPort      = 27017
          protocol      = "tcp"
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/testbackendshuo"
          mode                  = "non-blocking"
          awslogs-create-group  = "true"
          max-buffer-size       = "25m"
          awslogs-region        = "ap-southeast-2"
          awslogs-stream-prefix = "ecs"
        }
      }
      systemControls = []
    },
    {
      name   = "testapplication"
      image  = "public.ecr.aws/a9h1i7z6/threemay/goexpertbackendtest:edd0afb644c1f8e48216482e620803d79f999648"
      cpu    = 256
      memory = 512
      portMappings = [
        {
          name          = "testapplication-8080-tcp"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      essential = true
      environment = [
        {
          name  = "PORT"
          value = "80"
        },
        {
          name  = "CONNECTION_STRING"
          value = "mongodb://localhost:27017/goexpert"
        },
        {
          name  = "BACKEND_HOST_ADDRESS"
          value = "http://localhost:80"
        }
      ]
      dependsOn = [
        {
          containerName = "mongodb"
          condition     = "START"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/testbackendshuo"
          mode                  = "non-blocking"
          awslogs-create-group  = "true"
          max-buffer-size       = "25m"
          awslogs-region        = "ap-southeast-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "example" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  #   task_definition = "arn:aws:ecs:ap-southeast-2:586520679870:task-definition/testbackendshuo:6"
  desired_count = 1
  launch_type   = "FARGATE"
  network_configuration {
    subnets         = ["subnet-0b48a9952b69b2d6b", "subnet-03d540a5004760e77", "subnet-04b7ffe2f693e7242"]
    security_groups = ["sg-0966d087c015abf1d"]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.example.arn
    container_name   = "testapplication"
    container_port   = 80
  }
}

resource "aws_lb" "example" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0966d087c015abf1d"]
  subnets            = ["subnet-06011c654ace99e0f", "subnet-0501b03079d5cf7c4", "subnet-0148008e728800ef3"]
}

resource "aws_lb_target_group" "example" {
  name        = "example-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0b487883bd672f9c4"
  target_type = "ip"
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}
