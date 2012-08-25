package com.mesh
{
    public interface IPixelController
    {
        function updatePixel(pixel:Pixel):void;
        function transferPixel(pixel:Pixel, newController:IPixelController):void;
        function addPixel(pixel:Pixel):void;
        function removePixel(pixel:Pixel):void;
    }
}