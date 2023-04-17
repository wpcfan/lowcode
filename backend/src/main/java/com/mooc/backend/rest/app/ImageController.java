package com.mooc.backend.rest.app;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.*;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

@Tag(name = "图像", description = "动态生成图像")
@Validated
@RestController
@RequestMapping(value = "/api/v1/image")
public class ImageController {

    @Operation(summary = "根据宽度、高度、文本、背景颜色和文本颜色生成图像")
    @GetMapping("")
    public ResponseEntity<byte[]> query(
            @Parameter(description = "图像的宽度", name = "width", example = "200")
            @RequestParam(required = false, defaultValue = "200") @Min(12) @Max(1920) int width,
            @Parameter(description = "图像的高度", name = "height", example = "200")
            @RequestParam(required = false, defaultValue = "200") @Min(12) @Max(1920) int height,
            @Parameter(description = "显示在图像上的文本", name = "text", example = "Hello")
            @RequestParam(required = false, defaultValue = "Hello") @Size(min = 1, max = 20) String text,
            @Parameter(description = "图像的背景颜色", name = "backgroundColor", example = "ffffff")
            @RequestParam(required = false, defaultValue = "ffffff") @Pattern(regexp = "^[0-9a-fA-F]{6}$") String backgroundColor,
            @Parameter(description = "文本的颜色", name = "textColor", example = "000000")
            @RequestParam(required = false, defaultValue = "000000") @Pattern(regexp = "^[0-9a-fA-F]{6}$") String textColor) throws IOException {
        return buildImageResponseEntity(width, height, text, hexToColor(backgroundColor), hexToColor(textColor));
    }

    @Operation(summary = "根据宽度生成灰色图像")
    @GetMapping(value = "/{width}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图像的宽度", name = "width", example = "200")
            @PathVariable @Min(12) @Max(1920) int width) throws IOException {
        return buildImageResponseEntity(width, width, width + "x" + width, Color.GRAY, Color.BLACK);
    }

    @Operation(summary = "根据宽度和高度生成灰色图像")
    @GetMapping("/{width}/{height}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图像的宽度", name = "width", example = "200")
            @PathVariable @Min(12) @Max(1920) int width,
            @Parameter(description = "图像的高度", name = "height", example = "200")
            @PathVariable @Min(12) @Max(1920) int height) throws IOException {
        return buildImageResponseEntity(width, height, width + "x" + height, Color.GRAY, Color.BLACK);
    }

    @Operation(summary = "根据宽度、高度和文本生成灰色图像")
    @GetMapping("/{width}/{height}/{text}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图像的宽度", name = "width", example = "200")
            @PathVariable @Min(12) @Max(1920) int width,
            @Parameter(description = "图像的高度", name = "height", example = "200")
            @PathVariable @Min(12) @Max(1920) int height,
            @Parameter(description = "显示在图像上的文本", name = "text", example = "Hello")
            @PathVariable @NotBlank @Size(min = 1, max = 20) String text) throws IOException {
        return buildImageResponseEntity(width, height, text, Color.GRAY, Color.BLACK);
    }

    @Operation(summary = "根据宽度、高度、文本和背景颜色生成图像")
    @GetMapping("/{width}/{height}/{text}/{backgroundColor}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图像的宽度", name = "width", example = "200")
            @PathVariable @Min(12) @Max(1920) int width,
            @Parameter(description = "图像的高度", name = "height", example = "200")
            @PathVariable @Min(12) @Max(1920) int height,
            @Parameter(description = "显示在图像上的文本", name = "text", example = "Hello")
            @PathVariable @NotBlank @Size(min = 1, max = 20) String text,
            @Parameter(description = "图像背景色", name = "backgroundColor", example = "ffffff")
            @PathVariable @Pattern(regexp = "^[0-9a-fA-F]{6}$") String backgroundColor) throws IOException {
        return buildImageResponseEntity(width, height, text, hexToColor(backgroundColor), Color.BLACK);
    }

    @Operation(summary = "根据宽度、高度、文本、背景颜色和前景颜色生成图像")
    @GetMapping("/{width}/{height}/{text}/{backgroundColor}/{foregroundColor}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图像的宽度", name = "width", example = "200")
            @PathVariable @Min(12) @Max(1920) int width,
            @Parameter(description = "图像的高度", name = "height", example = "200")
            @PathVariable @Min(12) @Max(1920) int height,
            @Parameter(description = "显示在图像上的文本", name = "text", example = "Hello")
            @PathVariable @NotBlank @Size(min = 1, max = 20) String text,
            @Parameter(description = "图像背景色", name = "backgroundColor", example = "ffffff")
            @PathVariable @Pattern(regexp = "^[0-9a-fA-F]{6}$") String backgroundColor,
            @Parameter(description = "图像前景色", name = "foregroundColor", example = "000000")
            @PathVariable @Pattern(regexp = "^[0-9a-fA-F]{6}$") String foregroundColor) throws IOException {
        return buildImageResponseEntity(width, height, text, hexToColor(backgroundColor), hexToColor(foregroundColor));
    }

    private static Color hexToColor(String hex) {
        return new Color(Integer.parseInt(hex, 16));
    }
    private static ResponseEntity<byte[]> buildImageResponseEntity(int width, int height, String text, Color backgroundColor, Color foregroundColor) throws IOException {
        // 创建一个BufferedImage对象
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        // 获取Graphics2D对象
        Graphics2D g = image.createGraphics();
        // 设置背景颜色
        g.setColor(backgroundColor);
        // 填充背景
        g.fillRect(0, 0, width, height);
        // 设置前景颜色
        g.setColor(foregroundColor);
        if (text != null) {
            // 设置字体
            g.setFont(new Font("Arial", Font.BOLD, 20));
            // 获得FontMetrics对象，用于计算文本的宽高
            FontMetrics fm = g.getFontMetrics();
            // 得到绘制文本的起始位置 x, y
            int x = (width - fm.stringWidth(text)) / 2;
            int y = (fm.getAscent() + (height - (fm.getAscent() + fm.getDescent())) / 2);
            // 绘制文本
            g.drawString(text, x, y);
        }
        // 释放资源
        g.dispose();
        // 创建一个字节数组输出流
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        // 将BufferedImage对象写入到字节数组输出流中
        ImageIO.write(image, "png", baos);
        return ResponseEntity.ok().contentType(MediaType.IMAGE_PNG).body(baos.toByteArray());
    }
}
