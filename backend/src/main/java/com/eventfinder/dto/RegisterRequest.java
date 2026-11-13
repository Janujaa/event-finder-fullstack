package com.eventfinder.dto;
import jakarta.validation.constraints.*;
public record RegisterRequest(@NotBlank @Size(min=2,max=80) String name,@NotBlank @Email String email,@NotBlank @Size(min=8) String password) {}