variable "myvpc" {
    type = string
    default = "vpc-default"
}

variable "mylist" {
    type = list(string)
    default = [ "value1", "value2" ]
}

variable "mylist" {
    type = map(string)
    default = {
      key1 = "value1",
      key2 = "value2"
    }
}

variable "isTrue" {
    type = bool
    default = false
}

//to set the input variable
variable "inputname" {
    type = string
    description = "set input name"
}

//output  - to output the details of the resource
output "vpc-id" {
    value = aws_instance.web.id
}

variable "mytuple" {
    type = tuple([ string, number, string ])
    default = [ "car", 20, "red" ]
}

variable "myobject" {
    type = object({
      name = string,
      port = list(number)
    })
  default = {
    name = "TJ"
    port = [22,23,24]
  }
}