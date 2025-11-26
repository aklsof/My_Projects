package entity;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.IOException;
import javax.imageio.ImageIO;
import main.GamePanel;
import main.KeyHandler;

public class Player extends Entity {

    GamePanel gp;
    KeyHandler keyH;

    public final int screenX;
    public final int screenY;

    // PHYSICS
    int gravity = 1;
    int jumpStrength = 16;
    int yVelocity = 0;
    boolean isJumping = false;
    boolean onGround = false;

    Rectangle solidArea;
    int solidAreaDefaultX, solidAreaDefaultY;

    public BufferedImage up1, up2, down1, down2, left1, left2, right1, right2;
    public BufferedImage idle, jump;
    public String direction;
    public int spriteCounter = 0;
    public int spriteNum = 1;

    public Player(GamePanel gp, KeyHandler keyH) {
        this.gp = gp;
        this.keyH = keyH;

        screenX = gp.screenWidth / 2 - (gp.tileSize / 2);
        screenY = gp.screenHeight / 2 - (gp.tileSize / 2);

        solidArea = new Rectangle();
        solidArea.x = 8;
        solidArea.y = 16;
        solidAreaDefaultX = solidArea.x;
        solidAreaDefaultY = solidArea.y;
        solidArea.width = 32;
        solidArea.height = 32;

        setDefaultValues();
    }

    public void setDefaultValues() {
        x = 100;
        y = 100;
        speed = 4;
        direction = "right";
        getPlayerImage();
    }

    public void getPlayerImage() {
        try {
            // Load images (assuming they will exist)
            // For now, we might fail if they don't exist, so we catch exception
            idle = ImageIO.read(getClass().getResourceAsStream("/player/mario_idle.png"));
            // jump =
            // ImageIO.read(getClass().getResourceAsStream("/player/mario_jump.png"));

            // Re-using idle for now to avoid crashes if others missing
            jump = idle;
            left1 = idle;
            right1 = idle;

        } catch (Exception e) {
            // e.printStackTrace(); // Ignore missing images for now
        }
    }

    public void update() {

        // GRAVITY
        yVelocity += gravity;

        // LIMIT FALL SPEED
        if (yVelocity > 15) {
            yVelocity = 15;
        }

        // CHECK VERTICAL COLLISION
        int entityTopWorldY = y + yVelocity + solidArea.y;
        int entityBottomWorldY = y + yVelocity + solidArea.y + solidArea.height;

        int entityLeftCol = (x + solidArea.x) / gp.tileSize;
        int entityRightCol = (x + solidArea.x + solidArea.width) / gp.tileSize;

        int entityTopRow = entityTopWorldY / gp.tileSize;
        int entityBottomRow = entityBottomWorldY / gp.tileSize;

        if (yVelocity > 0) { // Falling
            // Check bottom corners
            if (isSolid(entityLeftCol, entityBottomRow) || isSolid(entityRightCol, entityBottomRow)) {
                // Collision detected below
                yVelocity = 0;
                isJumping = false;
                onGround = true;
                // Snap to grid
                y = entityBottomRow * gp.tileSize - solidArea.y - solidArea.height;
            } else {
                onGround = false;
                y += yVelocity;
            }
        } else if (yVelocity < 0) { // Jumping
            // Check top corners
            if (isSolid(entityLeftCol, entityTopRow) || isSolid(entityRightCol, entityTopRow)) {
                // Collision detected above
                yVelocity = 0;
                y = entityTopRow * gp.tileSize + gp.tileSize - solidArea.y;
            } else {
                y += yVelocity;
            }
        }

        // JUMPING
        if (keyH.jumpPressed && onGround) {
            yVelocity = -jumpStrength;
            isJumping = true;
            onGround = false;
        }

        // HORIZONTAL MOVEMENT
        if (keyH.leftPressed) {
            direction = "left";
            // Check left collision
            int entityLeftWorldX = x - speed + solidArea.x;
            int entityTopRowY = (y + solidArea.y) / gp.tileSize;
            int entityBottomRowY = (y + solidArea.y + solidArea.height - 1) / gp.tileSize; // -1 buffer
            int entityLeftColX = entityLeftWorldX / gp.tileSize;

            if (!isSolid(entityLeftColX, entityTopRowY) && !isSolid(entityLeftColX, entityBottomRowY)) {
                x -= speed;
            }
        }
        if (keyH.rightPressed) {
            direction = "right";
            // Check right collision
            int entityRightWorldX = x + speed + solidArea.x + solidArea.width;
            int entityTopRowY = (y + solidArea.y) / gp.tileSize;
            int entityBottomRowY = (y + solidArea.y + solidArea.height - 1) / gp.tileSize; // -1 buffer
            int entityRightColX = entityRightWorldX / gp.tileSize;

            if (!isSolid(entityRightColX, entityTopRowY) && !isSolid(entityRightColX, entityBottomRowY)) {
                x += speed;
            }
        }

        // CHECK MAP BOUNDS
        if (x < 0)
            x = 0;
        if (y > gp.worldHeight) {
            // Reset if fell off
            x = 100;
            y = 100;
            yVelocity = 0;
        }

        checkMonsterCollision();
    }

    public void checkMonsterCollision() {
        for (int i = 0; i < gp.monsters.size(); i++) {
            Entity monster = gp.monsters.get(i);
            if (monster != null) {
                // Get player solid area position
                int pLeft = x + solidArea.x;
                int pRight = x + solidArea.x + solidArea.width;
                int pTop = y + solidArea.y;
                int pBottom = y + solidArea.y + solidArea.height;

                // Get monster solid area position
                int mLeft = monster.x;
                int mRight = monster.x + 32;
                int mTop = monster.y;
                int mBottom = monster.y + 32;

                if (pRight > mLeft && pLeft < mRight && pBottom > mTop && pTop < mBottom) {
                    // Collision detected
                    if (yVelocity > 0 && y < monster.y) {
                        // Stomp!
                        ((Goomba) monster).alive = false;
                        gp.monsters.remove(i);
                        yVelocity = -10; // Bounce
                    } else {
                        // Ouch!
                        x = 100;
                        y = 100;
                    }
                }
            }
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
        BufferedImage image = null;

        if (idle != null) {
            image = idle;
        }

        if (image != null) {
            g2.drawImage(image, screenX, screenY, gp.tileSize, gp.tileSize, null);
        } else {
            // Programmatic Mario (Fallback)
            // Head
            g2.setColor(new Color(255, 0, 0)); // Red Hat
            g2.fillRect(screenX + 12, screenY + 4, 24, 8);

            // Face
            g2.setColor(new Color(255, 220, 177)); // Skin
            g2.fillRect(screenX + 12, screenY + 12, 24, 12);

            // Body
            g2.setColor(new Color(0, 0, 255)); // Blue Overalls
            g2.fillRect(screenX + 16, screenY + 24, 16, 16);

            // Arms
            g2.setColor(new Color(255, 0, 0)); // Red Shirt
            g2.fillRect(screenX + 4, screenY + 24, 12, 12);
            g2.fillRect(screenX + 32, screenY + 24, 12, 12);
        }

        // DEBUG INFO
        g2.setColor(Color.white);
        g2.drawString("X: " + x + " Y: " + y, screenX - 20, screenY - 10);
        g2.drawString("OnGround: " + onGround, screenX - 20, screenY - 25);
        g2.drawString("Col: " + (x / gp.tileSize) + " Row: " + (y / gp.tileSize), screenX - 20, screenY - 40);

        // Draw Collision Box
        g2.setColor(Color.red);
        g2.drawRect(screenX + solidArea.x, screenY + solidArea.y, solidArea.width, solidArea.height);
    }
}
