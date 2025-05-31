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

    public void addCourse(Course course, String owner) {
        log.info("Adding course with id {} for {}", course.getId(), course.getOwner());

        course.setId(UUID.randomUUID().toString());
        course.setOwner(owner);
        log.info("Course entity saved to DynamoDB");
        courseTable.putItem(course);
    }

    public List<Course> getAllCourses(String owner) {
        log.info("Getting all courses from DynamoDB");
        return courseTable.scan()
                .items()
                .stream()
                .filter(course -> owner.equals(course.getOwner()))
                .toList();
    }

    public Optional<Course> getCourseById(String id, String owner) {
        log.info("Getting course with ID {} from DynamoDB", id);
        Course course = courseTable.getItem(r -> r.key(k -> k.partitionValue(id)));
        return (course != null && owner.equals(course.getOwner()))
                ? Optional.of(course)
                : Optional.empty();
    }

    public boolean updateCourse(Course newCourse,String id, String owner) {
        log.info("Updating course with ID {} from DynamoDB", id);
        Course existing = courseTable.getItem(r -> r.key(k -> k.partitionValue(id)));
        if (existing == null || !owner.equals(existing.getOwner()))
            return false;

        newCourse.setId(id);
        newCourse.setOwner(owner);
        courseTable.putItem(newCourse);
        return true;
    }

    public boolean deleteCourse(String id, String owner) {
        log.info("Deleting course with ID {} from DynamoDB", id);
        Course existing = courseTable.getItem(r -> r.key(k -> k.partitionValue(id)));
        if (existing == null || !owner.equals(existing.getOwner()))
            return false;

        courseTable.deleteItem(existing);
        return true;
    }
}