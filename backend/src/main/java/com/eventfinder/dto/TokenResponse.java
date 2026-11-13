package com.eventfinder.dto;
import com.eventfinder.model.User;
public record TokenResponse(String token,User user) {}