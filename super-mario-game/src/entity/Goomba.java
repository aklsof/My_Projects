package entity;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import main.GamePanel;

public class Goomba extends Entity {

    GamePanel gp;
    public boolean alive = true;

    // Physics
    int gravity = 1;
    int yVelocity = 0;
    Rectangle solidArea = new Rectangle(0, 0, 32, 32);

    public Goomba(GamePanel gp, int startX, int startY) {
        this.gp = gp;
        this.x = startX;
        this.y = startY;

        speed = 2;
        direction = "left";

        solidArea.x = 0;
        solidArea.y = 0;
        solidArea.width = 32;
        solidArea.height = 32;

        getImage();
    }

    public void getImage() {
        try {
            // Placeholder or load image
            // up1 = ImageIO.read(getClass().getResourceAsStream("/enemies/goomba.png"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update() {
        if (!alive)
            return;

        // Gravity
        yVelocity += gravity;
        if (yVelocity > 15)
            yVelocity = 15;

        // Vertical Collision
        int entityBottomRow = (y + yVelocity + 32) / gp.tileSize;
        int entityCol = (x + 16) / gp.tileSize; // Center

        if (isSolid(entityCol, entityBottomRow)) {
            yVelocity = 0;
            y = entityBottomRow * gp.tileSize - 32;
        } else {
            y += yVelocity;
        }

        // Horizontal Movement & Collision
        if (direction.equals("left")) {
            int leftCol = (x - speed) / gp.tileSize;
            int row = (y + 16) / gp.tileSize;
            if (isSolid(leftCol, row)) {
                direction = "right";
            } else {
                x -= speed;
            }
        } else {
            int rightCol = (x + speed + 32) / gp.tileSize;
            int row = (y + 16) / gp.tileSize;
            if (isSolid(rightCol, row)) {
                direction = "left";
            } else {
                x += speed;
            }
        }

        // Fall off world
        if (y > gp.worldHeight) {
            alive = false;
        }
    }

    private boolean isSolid(int col, int row) {
        if (col < 0 || col >= gp.maxWorldCol || row < 0 || row >= gp.maxWorldRow) {
            return false;
        }
        int tileNum = gp.tileM.mapTileNum[col][row];
        return gp.tileM.tile[tileNum].collision;
    }

    public void draw(Graphics2D g2) {
        if (!alive)
            return;

        int screenX = x - gp.player.x + gp.player.screenX;
        int screenY = y - gp.player.y + gp.player.screenY;

        if (x + gp.tileSize > gp.player.x - gp.player.screenX &&
                x - gp.tileSize < gp.player.x + gp.player.screenX &&
                y + gp.tileSize > gp.player.y - gp.player.screenY &&
                y - gp.tileSize < gp.player.y + gp.player.screenY) {

            g2.setColor(new Color(165, 42, 42)); // Brown
            g2.fillRect(screenX, screenY, gp.tileSize, gp.tileSize);
        }
    }
}
