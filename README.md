# terraform-basics

# terraform init
    1. Makes terraform.tfstate (상태 저장용 / 불변의 진리)
    2. .terraform (provider, plugin etc)

# pushing to git (.gitignore)
    Never commit .terraform 
    .tfstate is precious (best practice : remote backend to store ex. s3)

# Referencing resources
    ex. resource aws_vpc firstvpc { ... }
        resource aws_instance firstinstance {
            vpc_id = aws_vpc.firstvpc.id
        }
    ** check "list of available Attributes" 

# Variables
    To input variables into TF
    Definition : type = XX , default = XX 
    
    If no variable input -> terraform apply -> will PROMPT
    
    Pass in many variables at once -> terraform.tfvars
        - Just a KEY = VALUE pair document 
          Can make more than one (hello.tfvars, dev.tfvars etc)

    Useful links
        - variable definition precedence : https://www.terraform.io/language/values/variables#variable-definition-precedence

# Locals
    Just Variables within the same script (to just reference)

    ** locals - when defining 
    ** local - when using 

    DIFFERENCE from variables
        - not for input
        - $ need when used 
        - syntax is a bit different when creating 

# output
    Debugging purposes ! 

# metadata arguments
    * count
        resource aws_instance helloworld{
            count = 3
        }
    * output 
        output instance {
            value = aws_instance.helloworld[*].public_ip
            value = [ for instance in aws_instance.helloworld : instance.public_ip ]
        }
    * for each
        resource aws_instance foo {
            for_each {
                prod = t2.large
                dev  = t2.micro 
            }
            instance_type = each.value
            tags = {
                Name = "Test ${each.key}"
            }
        }
    * lifecycle 
        resource aws_instance foo{ 
            lifecycle = {
                create_before_destroy = true 
                prevent_destroy = true 
                ignore_changes = true
            }
        }
    * expression 
        foo = local.baz == helloworld ? 1 : 2
        image_id = [ for k in key : k]
        for k, v in tags : upper(k)

# dynamic blocks
    https://www.terraform.io/language/expressions/dynamic-blocks#dynamic-blocks
    Inputting Variables -> depending on # of vars -> will create that much resources
        * for_each {var }


# provisioner 
    Should always be a last resort 
    * local-exec
    https://www.terraform.io/language/resources/provisioners/local-exec#local-exec-provisioner
        - To run command lines
        - will only run first & destroy time 
    * remote-exec 
    https://www.terraform.io/language/resources/provisioners/remote-exec#remote-exec-provisioner
        - To run command lines INSIDE the EC2
        - If fails, next time terraform apply will recreate the whole instance (prevent by on_failure)
    * file 
    https://www.terraform.io/language/resources/provisioners/file#file-provisioner
        - files can also be copied to EC2

# modules TBD 


# workspace 
    For separate statefiles mostly 
        terraform workspace new dev
        -> inside terraform.tfstate.d -> there will be multiple states 
    Might need different variable files (def.tfvars, prod.tfvars) 

    - Can also refer as variable
        locals{ environment = ${terraform.workspace} }
        resource{ tag = local.environment }

# Backend & Remote State 
    State is precious !  - should always have single source
        - not recommended to store locally
        - S3, TFEnterprise, etc 
            (will lock when someone tf apply)
            
    Example S3 backend config : https://www.terraform.io/language/settings/backends/s3#example-configuration