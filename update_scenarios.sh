#!/bin/bash

# AI使用指南场景数据更新工具
# 功能：将模板文件中的$$json_data$$占位符替换为JSON文件内容

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认文件路径
TEMPLATE_FILE="ai_guide_app_template.html"
JSON_FILE="ai-guide.json"
OUTPUT_FILE="ai_guide_app.html"

# 显示帮助信息
show_help() {
    echo -e "${BLUE}AI使用指南场景数据更新工具${NC}"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -t, --template FILE    模板文件路径 (默认: $TEMPLATE_FILE)"
    echo "  -j, --json FILE        JSON数据文件路径 (默认: $JSON_FILE)"
    echo "  -o, --output FILE      输出文件路径 (默认: $OUTPUT_FILE)"
    echo "  -h, --help             显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                                    # 使用默认文件"
    echo "  $0 -t template.html -j data.json     # 指定自定义文件"
    echo "  $0 -o new_app.html                   # 指定输出文件"
    echo ""
}

# 检查文件是否存在
check_file() {
    local file="$1"
    local file_type="$2"
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}错误: $file_type 文件 '$file' 不存在${NC}"
        exit 1
    fi
}

# 验证JSON格式
validate_json() {
    local json_file="$1"
    
    if ! python3 -m json.tool "$json_file" > /dev/null 2>&1; then
        echo -e "${RED}错误: JSON文件 '$json_file' 格式无效${NC}"
        exit 1
    fi
}

# 主函数
main() {
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--template)
                TEMPLATE_FILE="$2"
                shift 2
                ;;
            -j|--json)
                JSON_FILE="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}错误: 未知参数 '$1'${NC}"
                show_help
                exit 1
                ;;
        esac
    done

    echo -e "${BLUE}开始更新场景数据...${NC}"
    echo "模板文件: $TEMPLATE_FILE"
    echo "JSON数据文件: $JSON_FILE"
    echo "输出文件: $OUTPUT_FILE"
    echo ""

    # 检查文件是否存在
    check_file "$TEMPLATE_FILE" "模板"
    check_file "$JSON_FILE" "JSON数据"

    # 验证JSON格式
    echo -e "${YELLOW}验证JSON格式...${NC}"
    validate_json "$JSON_FILE"
    echo -e "${GREEN}✓ JSON格式验证通过${NC}"

    # 检查模板文件中是否包含占位符
    if ! grep -q '\$\$json_data\$\$' "$TEMPLATE_FILE"; then
        echo -e "${RED}错误: 模板文件中未找到 '$$json_data$$' 占位符${NC}"
        exit 1
    fi

    # 读取JSON文件内容并转义特殊字符
    echo -e "${YELLOW}读取JSON数据...${NC}"
    JSON_CONTENT=$(cat "$JSON_FILE" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | tr '\n' ' ' | sed 's/  */ /g')

    # 用awk宽松匹配替换占位符（允许前后有空格）
    awk -v json="$JSON_CONTENT" '{gsub(/ *\$\$json_data\$\$ */, json)}1' "$TEMPLATE_FILE" > "$OUTPUT_FILE"

    if grep -q '\$\$json_data\$\$' "$OUTPUT_FILE"; then
        echo "错误: 占位符替换失败"
        exit 1
    fi

    # 验证输出文件
    if [[ ! -f "$OUTPUT_FILE" ]]; then
        echo -e "${RED}错误: 输出文件创建失败${NC}"
        exit 1
    fi

    # 显示统计信息
    SCENARIOS_COUNT=$(grep -o '"scene":' "$OUTPUT_FILE" | wc -l)
    STEPS_COUNT=$(grep -o '"step":' "$OUTPUT_FILE" | wc -l)
    OPTIONS_COUNT=$(grep -o '"content":' "$OUTPUT_FILE" | wc -l)

    echo -e "${GREEN}✓ 场景数据更新完成！${NC}"
    echo ""
    echo -e "${BLUE}统计信息:${NC}"
    echo "  场景数量: $SCENARIOS_COUNT"
    echo "  步骤数量: $STEPS_COUNT"
    echo "  选项数量: $OPTIONS_COUNT"
    echo ""
    echo -e "${GREEN}输出文件: $OUTPUT_FILE${NC}"
    echo -e "${YELLOW}提示: 可以直接在浏览器中打开 $OUTPUT_FILE 查看效果${NC}"
}

# 检查依赖
check_dependencies() {
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}错误: 需要安装 Python3 来验证JSON格式${NC}"
        exit 1
    fi
}

# 运行主程序
check_dependencies
main "$@" 