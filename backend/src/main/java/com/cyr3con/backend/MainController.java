package com.cyr3con.backend;

import java.util.ArrayList;
import java.util.List;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
public class MainController{

    private ArrayList<ShopItem> shopItems;

    @GetMapping("/")
    public String home(){
        return "Try /getSummary or /putItems";
    }

    @RequestMapping(value = "/putItems", method = RequestMethod.POST)
    public ResponseEntity<Object> createProduct(@RequestBody List<ShopItem> items) {
        
        try{
            if(items.size() > 2){
                return new ResponseEntity<>("Too many items", HttpStatus.BAD_REQUEST);     
            }
    
            if(shopItems.get(0).getItemStock() - items.get(0).getItemStock() < 0){
                return new ResponseEntity<>("Not enough units available for "+ shopItems.get(0).getItemName(), HttpStatus.BAD_REQUEST);     
            }else{
                shopItems.get(0).setItemStock(shopItems.get(0).getItemStock() - items.get(0).getItemStock());
            }
    
            if(shopItems.get(1).getItemStock() - items.get(1).getItemStock() < 0){
                return new ResponseEntity<>("Not enough units available for "+ shopItems.get(1).getItemName(), HttpStatus.BAD_REQUEST);     
            }else{
                shopItems.get(1).setItemStock(shopItems.get(1).getItemStock() - items.get(1).getItemStock());
            }
    
           return new ResponseEntity<>(items, HttpStatus.CREATED);
        }catch (Exception e){
            return new ResponseEntity<>("Bad arguments", HttpStatus.BAD_REQUEST);
        }
    }

    @RequestMapping(value = "/getSummary", method = RequestMethod.GET)
    public ResponseEntity<Object> getSummary() {
       return new ResponseEntity<>(shopItems, HttpStatus.OK);
    }

    @RequestMapping(value = "/reset", method = RequestMethod.GET)
    public ResponseEntity<Object> reset() {
        populateItems();
       return new ResponseEntity<>("Reset Completed", HttpStatus.OK);
    }
    
    @EventListener(ApplicationReadyEvent.class)
    public void populateItems() {
        shopItems = new ArrayList<>();
        shopItems.add(new ShopItem(1, "Item 1", 20));
        shopItems.add(new ShopItem(2, "Item 2", 10));
    }

}