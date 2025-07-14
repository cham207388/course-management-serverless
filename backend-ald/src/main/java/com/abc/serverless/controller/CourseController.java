package com.abc.serverless.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.abc.serverless.dto.Course;
import com.abc.serverless.security.SecurityService;
import com.abc.serverless.service.CourseService;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/courses")
@RequiredArgsConstructor
public class CourseController {

    private final CourseService courseService;
    private final SecurityService securityService;


    @PostMapping(produces = "application/json", consumes = "application/json")
    public ResponseEntity<Course> addCourse(@RequestBody Course course, HttpServletRequest request) {
        String username = securityService.extractUsernameFromToken(request);
        courseService.addCourse(course, username);
        return new ResponseEntity<>(course, HttpStatus.CREATED);
    }

    @GetMapping(produces = "application/json")
    public ResponseEntity<List<Course>> getAllCourses(HttpServletRequest request) {
        String username = securityService.extractUsernameFromToken(request);
        List<Course> courses = courseService.getAllCourses(username);
        return new ResponseEntity<>(courses, HttpStatus.OK);
    }

    @GetMapping(value = "/{id}", produces = "application/json")
    public ResponseEntity<Course> getCourseById(@PathVariable String id, HttpServletRequest request) {
        String username = securityService.extractUsernameFromToken(request);
        Optional<Course> course = courseService.getCourseById(id, username);
        return course.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @GetMapping(value = "/name/{name}", produces = "application/json")
    public ResponseEntity<Course> getCourseByName(@PathVariable String name, HttpServletRequest request) {
        String username = securityService.extractUsernameFromToken(request);
        Optional<Course> course = courseService.getCourseByName(name, username);
        return course.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PutMapping(value = "/{id}", produces = "application/json", consumes = "application/json")
    public ResponseEntity<Course> updateCourse(@RequestBody Course updatedCourse, @PathVariable String id, HttpServletRequest request) {
        String username = securityService.extractUsernameFromToken(request);
        boolean updated = courseService.updateCourse(updatedCourse, id, username);
        return updated ? new ResponseEntity<>(HttpStatus.NO_CONTENT) : new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> deleteCourse(@PathVariable String id, HttpServletRequest request) {
        String username = securityService.extractUsernameFromToken(request);
        boolean deleted = courseService.deleteCourse(id, username);
        return deleted ? new ResponseEntity<>(HttpStatus.NO_CONTENT) : new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
}
