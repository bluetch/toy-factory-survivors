# Toy Factory Survivors

## 介紹 (Introduction)
歡迎來到《Toy Factory Survivors》！這是一款啟發自《吸血鬼倖存者 (Vampire Survivors)》的自動射擊動作遊戲。在混亂的玩具工廠中，扮演勇敢的角色，面對無窮無盡的玩具敵人浪潮。收集經驗寶石來升級你的能力，解鎖新技能，並生存下來！

## 遊戲特色 (Features)
- **經典倖存者玩法**: 在不斷湧來的敵人群中生存，考驗你的戰略和反應。
- **自由移動**: 角色可以在地圖上自由移動，躲避敵人並尋找最佳戰鬥位置。
- **自動射擊**: 專注於移動和走位，武器會自動攻擊最近的敵人。
- **豐富的升級系統**: 收集經驗寶石提升等級，從多樣化的升級選項中強化你的角色。
- **多樣的玩具敵人**: 面對各式各樣具有獨特行為模式的玩具敵人。
- **自適應視窗**: 遊戲視窗可自由縮放，畫面內容會隨之調整，提供更好的遊戲體驗。
- **音效系統**: 沉浸於戰鬥音效、升級提示、拾取寶石等音效中（部分音效需自行添加）。

## 使用技術 (Technologies Used)
- **Godot Engine 4.x**: 開發此遊戲的主要引擎。
- **GDScript**: Godot 引擎的內建腳本語言，用於遊戲邏輯編程。

## 如何運行遊戲 (How to Run the Game)

### 1. 安裝 Godot Engine
如果尚未安裝 Godot Engine 4.x，請從 [Godot Engine 官方網站](https://godotengine.org/download) 下載並安裝。

### 2. 克隆專案
```bash
git clone https://github.com/bluetch/toy-factory-survivors.git
cd toy-factory-survivors
```

### 3. 開啟專案
啟動 Godot Engine，然後點擊「匯入 (Import)」或「開啟專案 (Open Project)」，選擇您克隆下來的 `toy-factory-survivors` 專案資料夾中的 `project.godot` 文件。

### 4. 運行遊戲
在 Godot 編輯器中，點擊右上角的「運行 (Run)」按鈕（通常是一個播放圖示），即可開始遊戲。

## 音效設定 (Sound Setup)
目前遊戲已建立音效系統，但部分音效文件需要您自行提供。
1.  **準備音效檔案：**
    *   為以下事件找到合適的 `.wav` 或 `.ogg` 音效檔案：
        *   玩家受傷
        *   敵人死亡
        *   收集經驗寶石
        *   玩家升級
    *   將這些檔案重新命名為：
        *   `player_hurt.wav` (或 `.ogg`)
        *   `enemy_death.wav` (或 `.ogg`)
        *   `pickup.wav` (或 `.ogg`)
        *   `level_up.wav` (或 `.ogg`)
2.  **將音效檔案放入專案中：**
    *   將所有這些重新命名的音效檔案移至 `assets/audio/` 目錄。
3.  **修改 `scripts/sound_manager.gd`：**
    *   開啟 `scripts/sound_manager.gd`。
    *   在 `_ready()` 函式中，新增載入其他音效的程式碼。例如：
        ```gdscript
        player_hurt_stream = load("res://assets/audio/player_hurt.wav")
        enemy_death_stream = load("res://assets/audio/enemy_death.wav")
        pickup_stream = load("res://assets/audio/pickup.wav")
        level_up_stream = load("res://assets/audio/level_up.wav")
        ```
    *   在 `play_sound()` 函式中的 `match sound_name:` 區塊中，新增對應音效的 `stream` 指派。例如：
        ```gdscript
        match sound_name:
            "shoot":
                audio_player.stream = shoot_stream
            "player_hurt":
                audio_player.stream = player_hurt_stream
            "enemy_death":
                audio_player.stream = enemy_death_stream
            "pickup":
                audio_player.stream = pickup_stream
            "level_up":
                audio_player.stream = level_up_stream
        ```

## 貢獻 (Contributing)
歡迎所有形式的貢獻！如果您有任何建議、錯誤報告或功能請求，請隨時提交 Issue 或 Pull Request。

## 授權 (License)
[請在此處填寫您的授權資訊，例如 MIT 授權、GPL 等]

## 鳴謝 (Acknowledgements)
- 啟發自《吸血鬼倖存者 (Vampire Survivors)》。
- [您可以在此處添加其他您想要鳴謝的資源或個人。]