package com.serrala.textserach.domain;

import javax.persistence.*;
import org.hibernate.annotations.Table;

@Entity
@Table(appliesTo = "B")
public class B {

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
        return "B{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
