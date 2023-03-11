package com.mooc.backend.rest.app;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

@RestController
@RequestMapping(value = "/api/v1/image")
public class ImageController {

    @GetMapping("/{width}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width) throws IOException {
        return buildImageResponseEntity(width, width, width + "x" + width, Color.GRAY, Color.BLACK);
    }

    @GetMapping("/{width}/{height}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width, @PathVariable int height) throws IOException {
        return buildImageResponseEntity(width, height, width + "x" + height, Color.GRAY, Color.BLACK);
    }

    @GetMapping("/{width}/{height}/{text}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width, @PathVariable int height, @PathVariable String text) throws IOException {
        return buildImageResponseEntity(width, height, text, Color.GRAY, Color.BLACK);
    }

    @GetMapping("/{width}/{height}/{text}/{backgroundColor}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width, @PathVariable int height, @PathVariable String text, @PathVariable String backgroundColor) throws IOException {
        return buildImageResponseEntity(width, height, text, hexToColor(backgroundColor), Color.BLACK);
    }

    @GetMapping("/{width}/{height}/{text}/{backgroundColor}/{foregroundColor}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width, @PathVariable int height, @PathVariable String text, @PathVariable String backgroundColor, @PathVariable String foregroundColor) throws IOException {
        return buildImageResponseEntity(width, height, text, hexToColor(backgroundColor), hexToColor(foregroundColor));
    }

    private static Color hexToColor(String hex) {
        return new Color(Integer.parseInt(hex, 16));
    }
    private static ResponseEntity<byte[]> buildImageResponseEntity(int width, int height, String text, Color backgroundColor, Color foregroundColor) throws IOException {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = image.createGraphics();
        g.setColor(backgroundColor);
        g.fillRect(0, 0, width, height);
        g.setColor(foregroundColor);
        if (text != null) {
            g.setFont(new Font("Arial", Font.BOLD, 20));
            FontMetrics fm = g.getFontMetrics();
            int x = (width - fm.stringWidth(text)) / 2;
            int y = (fm.getAscent() + (height - (fm.getAscent() + fm.getDescent())) / 2);
            g.drawString(text, x, y);
        }
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, "jpg", baos);
        return ResponseEntity.ok().contentType(MediaType.IMAGE_JPEG).body(baos.toByteArray());
    }
}
