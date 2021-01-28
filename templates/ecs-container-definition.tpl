[
    {
        "name": "${app-name}",
        "image": "${image}:${tag}",
        "memory": ${memory},
        "cpu": ${cpu},
        "essential": true,
        "portMappings": [
            {
                "containerPort": ${container-port},
                "protocol": "tcp"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${awslogs-group}",
                "awslogs-region": "${awslogs-region}",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "healthCheck": {
            "command": ${healthcheck-commands},
            "interval": 30,
            "startPeriod": 5,
            "retries": 5,
            "timeout": 60
        }
    }
]