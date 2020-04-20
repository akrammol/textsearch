package com.serrala.textserach.domain;

import org.hibernate.annotations.Table;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
@Table(appliesTo = "Text")
public class Text {

    @Id
    @GeneratedValue
    private Long id;

    @Column(name = "TAB_ID")
    private String tableId;

    @Column(name = "DUMMY", length = 1, columnDefinition = "CHAR")
    private String dummy;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTableId() {
        return tableId;
    }

    public void setTableId(String tableId) {
        this.tableId = tableId;
    }

    public String getDummy() {
        return dummy;
    }

    public void setDummy(String dummy) {
        this.dummy = dummy;
    }

    @Override
    public String toString() {
        return "Text{" +
                "id=" + id +
                ", tableId='" + tableId + '\'' +
                ", dummy='" + dummy + '\'' +
                '}';
    }
}
