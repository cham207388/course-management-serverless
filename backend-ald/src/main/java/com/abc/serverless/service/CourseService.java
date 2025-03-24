package com.abc.serverless.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.abc.serverless.dto.Course;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbTable;


@Slf4j
@Service
@RequiredArgsConstructor
public class CourseService {

    private final DynamoDbTable<Course> courseTable;

    public void addCourse(Course course) {
        log.info("Adding course request to DynamoDB: {}", course);

        course.setId(UUID.randomUUID().toString());
        log.info("Course entity saved to DynamoDB");
        courseTable.putItem(course);
    }

    public List<Course> getAllCourses() {
        log.info("Getting all courses from DynamoDB");
        return courseTable.scan()
                .items()
                .stream()
                .toList();
    }

    public Optional<Course> getCourseById(String id) {
        log.info("Getting course with ID {} from DynamoDB", id);
        return Optional.ofNullable(courseTable.getItem(r -> r.key(k -> k.partitionValue(id))));
    }

    public boolean updateCourse(String id, Course newCourse) {
        log.info("Updating course with ID {} from DynamoDB", id);
        Course existing = courseTable.getItem(r -> r.key(k -> k.partitionValue(id)));
        if (existing == null) return false;

        newCourse.setId(id);
        courseTable.putItem(newCourse);
        return true;
    }

    public boolean deleteCourse(String id) {
        log.info("Deleting course with ID {} from DynamoDB", id);
        Course existing = courseTable.getItem(r -> r.key(k -> k.partitionValue(id)));
        if (existing == null) return false;

        courseTable.deleteItem(existing);
        return true;
    }
}