//singleton Data Manager class
package com.simianlogic.managers{
 
  import flash.net.*;
  import flash.utils.*;

  public class DataManager {

    //singleton vars
    private static var instance:DataManager;
    private static var allowInstantiation:Boolean;
    public static var firstTime:Boolean = false;
    
    //SharedObject
    private var stats:SharedObject;
    
    //Lookup data for the game variables
    public var sharedObjectName:String;
    public var keys:Array;
    public var values:Array;
        
    
    public function DataManager(sharedObjectName:String, defaultKeys:Array = null, defaultValues:Array = null):void {
      if (!allowInstantiation) {
        throw new Error("Error: Instantiation failed: Use DataManager.getInstance() instead of new.");
      }
      
      this.sharedObjectName = sharedObjectName;
      this.keys   = defaultKeys;
      this.values = defaultValues;
      
      //Overwrite the defaults with any stored values
      loadData();
    }
    
    public static function setDefaults(keys:Array, values:Array):void
    {
      var dm:DataManager = DataManager.getInstance();
      dm.keys = keys;
      dm.values = values;
    }

    private function loadData():void
    {
      stats = SharedObject.getLocal(sharedObjectName);
      
      if(stats.size == 0)
      {
        DataManager.firstTime = true;
        //initialize default preference values
      }else{      
        DataManager.firstTime = false;        
        for(var i:int = 0; i < values.length; i++)
        {
          if(stats.data[keys[i]] != null) values[i] = stats.data[keys[i]];
        }
      }
      
    }
    
    public static function getStat(k:String):Object
    {
      var dm:DataManager = DataManager.getInstance();
      return dm.iGetStat(k);
    }
    
    private function iGetStat(k:String):Object
    {
      var which:int = keys.indexOf(k);
      return values[which];
    }
    
    public static function setStat(k:String, v:Object):void
    {
      var dm:DataManager = DataManager.getInstance();
      dm.iSetStat(k,v);
    }
    
    private function iSetStat(k:String, v:Object):void
    {
      if(stats == null)
      {
        return;
      }
      
      var which:int = keys.indexOf(k);
      values[which] = v;
      stats.data[k] = v;
      stats.flush();
    }    
    
    //used for storing a big arrays of booleans
    private function compressBooleanArray(a:Array):ByteArray
    {
      var b:ByteArray = new ByteArray();
      for(var i:int = 0; i < a.length; i++)
      {
        b.writeBoolean(a[i]);
      }
      return b;
    }
    
    //used for retrieving a big arrays of booleans
    private function expandBooleanArray(b:ByteArray):Array
    {
      if(b == null) return null;
      
      var a:Array = new Array(b.length);
      for(var i:int; i < b.length; i++)
      {
        a[i] = b.readBoolean();
      }
      return a;
    }    


    
    public static function getInstance(sharedObjectName:String=null, defaultKeys:Array = null, defaultValues:Array = null):DataManager {
      if (instance == null) {
          if(sharedObjectName == null)
          {
              throw new Error("You must supply a shared object name the first time you call DataManager.getInstance!");
          }
          allowInstantiation = true;
          instance = new DataManager(sharedObjectName, defaultKeys, defaultValues);
          allowInstantiation = false;
      }
      
      return instance;
    }    
    
  }
}