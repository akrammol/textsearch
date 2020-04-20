package com.serrala.textsearch.domain;

import org.hibernate.annotations.Table;

import javax.persistence.*;

@Entity
@Table(appliesTo = "C")
public class C {

    @Id
    @GeneratedValue
    private Long id;

    @Column(name = "COL_NAME")
    private String name;

    @Column(name = "COL_DESCRIPTION")
    private String description;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "C{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
