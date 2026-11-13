package com.eventfinder.model;
import java.time.LocalDate; import java.time.LocalTime;
public record Event(Long id,String title,String description,Long categoryId,String category,LocalDate eventDate,LocalTime startTime,LocalTime endTime,String venue,String location,String imageUrl,String organiserName,String organiserEmail,Integer capacity,Integer registeredCount,Long createdBy) {}