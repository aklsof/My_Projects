package tile;

import java.awt.Color;
import java.awt.Graphics2D;
import java.io.IOException;
import javax.imageio.ImageIO;
import main.GamePanel;

public class TileManager {
    GamePanel gp;
    public Tile[] tile;
    public int mapTileNum[][];

    public TileManager(GamePanel gp) {
        this.gp = gp;
        tile = new Tile[10];
        mapTileNum = new int[gp.maxWorldCol][gp.maxWorldRow];

        getTileImage();

        for (int row = 0; row < gp.maxWorldRow; row++) {
            for (int col = 0; col < gp.maxWorldCol; col++) {
                if (row >= 10) {
                    mapTileNum[col][row] = 1; // Ground at bottom
                } else {
                    mapTileNum[col][row] = 0; // Sky
                }

                // Add some blocks
                if (row == 7 && col > 5 && col < 9) {
                    mapTileNum[col][row] = 2;
                }
            }
        }
    }

    public void getTileImage() {
        try {
            // 0 = Sky (Empty)
            tile[0] = new Tile();

            // 1 = Ground (Solid)
            tile[1] = new Tile();
            try {
                tile[1].image = ImageIO.read(getClass().getResourceAsStream("/tiles/ground_tile.png"));
            } catch (Exception e) {
            }
            tile[1].collision = true;

            // 2 = Block (Solid)
            tile[2] = new Tile();
            try {
                tile[2].image = ImageIO.read(getClass().getResourceAsStream("/tiles/block_tile.png"));
            } catch (Exception e) {
            }
            tile[2].collision = true;

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void draw(Graphics2D g2) {
        int worldCol = 0;
        int worldRow = 0;

        while (worldCol < gp.maxWorldCol && worldRow < gp.maxWorldRow) {
            int tileNum = mapTileNum[worldCol][worldRow];

            int worldX = worldCol * gp.tileSize;
            int worldY = worldRow * gp.tileSize;
            int screenX = worldX - gp.player.x + gp.player.screenX;
            int screenY = worldY - gp.player.y + gp.player.screenY;

            // Optimization: Only draw tiles that are visible
            if (worldX + gp.tileSize > gp.player.x - gp.player.screenX &&
                    worldX - gp.tileSize < gp.player.x + gp.player.screenX &&
                    worldY + gp.tileSize > gp.player.y - gp.player.screenY &&
                    worldY - gp.tileSize < gp.player.y + gp.player.screenY) {

                if (tileNum == 0) {
                    g2.setColor(new Color(135, 206, 235));
                    g2.fillRect(screenX, screenY, gp.tileSize, gp.tileSize);
                } else {
                    if (gp.tileM.tile[tileNum].image != null) {
                        g2.drawImage(gp.tileM.tile[tileNum].image, screenX, screenY, gp.tileSize, gp.tileSize, null);
                    } else {
                        // Fallback
                        if (tileNum == 1)
                            g2.setColor(new Color(139, 69, 19));
                        else if (tileNum == 2)
                            g2.setColor(Color.orange);
                        g2.fillRect(screenX, screenY, gp.tileSize, gp.tileSize);
                    }
                }
            }

            worldCol++;

            if (worldCol == gp.maxWorldCol) {
                worldCol = 0;
                worldRow++;
            }
        }
    }
}
