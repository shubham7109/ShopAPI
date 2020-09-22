
package com.cyr3con.backend;

public class ShopItem {

    private final long id;
    private final String itemName;
    private long itemStock;

    public ShopItem(final long id, final String itemName, final long itemStock) {
        this.id = id;
        this.itemName = itemName;
        this.itemStock = itemStock; 
    }

    public void setItemStock(long itemStock) {
        this.itemStock = itemStock;
    }

    public long getId() {
        return id;
    }

    public String getItemName() {
        return itemName;
    }

    public long getItemStock() {
        return itemStock;
    }
    
}