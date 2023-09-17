resource "aws_sfn_state_machine" "pet_state_machine" {
  name     = "pet_state_machine"
  role_arn = aws_iam_role.pet_step_function_role.arn

  definition = file("modules/pet-reminder-app/pet_step_function_code.json")
}

output "pet_state_machine_arn" {
  value = aws_sfn_state_machine.pet_state_machine.arn
  
}