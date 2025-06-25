# AI使用指南场景数据更新工具

## 功能说明

这个工具可以自动将 `ai_guide_app_template.html` 模板文件中的 `$$json_data$$` 占位符替换为 `ai-guide.json` 文件的内容，生成新的 `ai_guide_app.html` 文件，避免手工复制粘贴。

## 文件说明

- `update_scenarios.sh` - 主要的更新脚本
- `ai_guide_app_template.html` - 模板文件，包含 `$$json_data$$` 占位符
- `ai-guide.json` - 场景数据文件
- `ai_guide_app.html` - 生成的最终应用文件

## 使用方法

### 1. 基本用法（使用默认文件）

```bash
./update_scenarios.sh
```

这将使用默认文件：

- 模板文件：`ai_guide_app_template.html`
- JSON数据文件：`ai-guide.json`
- 输出文件：`ai_guide_app.html`

### 2. 指定自定义文件

```bash
# 指定模板文件
./update_scenarios.sh -t my_template.html

# 指定JSON数据文件
./update_scenarios.sh -j my_data.json

# 指定输出文件
./update_scenarios.sh -o new_app.html

# 同时指定多个文件
./update_scenarios.sh -t template.html -j data.json -o output.html
```

### 3. 查看帮助信息

```bash
./update_scenarios.sh -h
```

## 命令行选项

| 选项 | 长选项 | 说明 | 默认值 |
|------|--------|------|--------|
| `-t` | `--template` | 模板文件路径 | `ai_guide_app_template.html` |
| `-j` | `--json` | JSON数据文件路径 | `ai-guide.json` |
| `-o` | `--output` | 输出文件路径 | `ai_guide_app.html` |
| `-h` | `--help` | 显示帮助信息 | - |

## 工作流程

1. **检查依赖**：验证是否安装了 Python3（用于JSON格式验证）
2. **文件检查**：确认模板文件和JSON文件存在
3. **JSON验证**：验证JSON文件格式是否正确
4. **占位符检查**：确认模板文件中包含 `$$json_data$$` 占位符
5. **数据替换**：将JSON内容替换占位符
6. **结果验证**：确认替换成功并生成统计信息

## 输出示例

```text
开始更新场景数据...
模板文件: ai_guide_app_template.html
JSON数据文件: ai-guide.json
输出文件: ai_guide_app.html

验证JSON格式...
✓ JSON格式验证通过
读取JSON数据...
替换占位符...
✓ 场景数据更新完成！

统计信息:
  场景数量: 17
  步骤数量: 25
  选项数量: 67

输出文件: ai_guide_app.html
提示: 可以直接在浏览器中打开 ai_guide_app.html 查看效果
```

## 错误处理

工具会检查以下错误情况：

- 文件不存在
- JSON格式无效
- 模板文件中缺少占位符
- 占位符替换失败
- 输出文件创建失败

## 系统要求

- **操作系统**：Linux, macOS, Windows (WSL)
- **依赖**：Python3（用于JSON格式验证）
- **权限**：脚本需要执行权限

## 安装和设置

1. 确保脚本有执行权限：

   ```bash
   chmod +x update_scenarios.sh
   ```

2. 确保安装了 Python3：

   ```bash
   python3 --version
   ```

3. 准备文件：
   - 将 `ai_guide_app_template.html` 放在脚本同目录
   - 将 `ai-guide.json` 放在脚本同目录

## 注意事项

1. **备份**：建议在运行前备份原始文件
2. **JSON格式**：确保JSON文件格式正确，工具会自动验证
3. **占位符**：模板文件中必须包含 `$$json_data$$` 占位符
4. **编码**：确保文件使用UTF-8编码

## 故障排除

### 常见问题

1. **权限错误**：

   ```bash
   chmod +x update_scenarios.sh
   ```

2. **Python3未安装**：

   ```bash
   # macOS
   brew install python3
   
   # Ubuntu/Debian
   sudo apt-get install python3
   ```

3. **文件路径错误**：
   确保所有文件都在正确的路径下，或使用绝对路径

4. **JSON格式错误**：
   使用在线JSON验证工具检查JSON文件格式

## 版本信息

- 版本：1.0.0
- 创建日期：2024年
- 作者：AI助手
