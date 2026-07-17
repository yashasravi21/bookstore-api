package com.example.bookstore;

import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/books")
public class BookController {

    private final List<Book> books = new ArrayList<>();

    public BookController() {
        books.add(new Book(1L, "Java Basics", "John"));
        books.add(new Book(2L, "Spring Boot", "David"));
    }

    @GetMapping
    public List<Book> getBooks() {
        return books;
    }

    @PostMapping
    public Book addBook(@RequestBody Book book) {
        books.add(book);
        return book;
    }
}
