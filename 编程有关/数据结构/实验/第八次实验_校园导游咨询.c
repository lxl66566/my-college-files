#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define NODE 5  // NODE 节点数
int edge[NODE + 1][NODE + 1] = {
    {},
    {0, 9999,5,15,7,3},
    {0, 5,9999,3,2,1},
    {0, 15,3,9999,9,30},
    {0, 7,2,9,9999,2},
    {0, 3,1,30,2,9999}
};  // 带权邻接矩阵。我们不关心邻接矩阵的构建过程，此处直接给出 1-5 个景点的连通情况。9999 表示不连通。
int i,j;      
struct scene
{
    int id;             // 编号
    char name[30];      // 名字
    char profile[300];  // 简介
}ecust[NODE + 1];

void init() // 初始化过程
{
    for(i = 1;i <= NODE;i++)
    {
        ecust[i].id = i;
        switch (i)
        {
            case 1:
                strcpy(ecust[i].name,"通海湖\0");
                strcpy(ecust[i].profile,"位于奉贤校区中央，南临正大门，北接图文信息中心，是一个由人工挖掘而成的浅水湖。");
                break;
            case 2:
                strcpy(ecust[i].name,"图书馆\0");
                strcpy(ecust[i].profile,"华东理工大学图书馆创建于 1952 年 10 月，目前由徐汇校区图书馆和奉贤校区图书馆组成，馆舍总面积达 4.4 万平方米。");
                break;
            case 3:
                strcpy(ecust[i].name,"大学生活动中心\0");
                strcpy(ecust[i].profile,"华东理工大学奉贤校区大学生活动中心集办公、会务、活动、娱乐等功能为一体，是我校学生各类校园文化活动的重要载体。");
                break;
            case 4:
                strcpy(ecust[i].name,"第一食堂\0");
                strcpy(ecust[i].profile,"华东理工大学奉贤校区第一食堂在暑假期间进行了全面升级，配备了现代化的装修、精致的桌椅和全新的菜品。");
                break;
            default:
                strcpy(ecust[i].name,"油菜花田\0");
                strcpy(ecust[i].profile,"油菜花海由学校艺术设计与传媒学院共同协助设计。“我们考虑采用片植的油菜花来体现花海的整体美，蜿蜒的形态则如同悦动的火舌，象征着华理师生互动生辉、群星闪耀。”");
                break;
        }
    }
}

int exit_message_info = 0;  // 记录是否退出信息查询子界面
void message_info()
{
    exit_message_info = 0;
    printf("信息查询，请输入你需要的查询条目\n0.退出\n1.按照id查询\n2.按照名字查询\n3.总览\n");
    int info;
    scanf("%d",&info);
    while(info < 0 || info > 3){   // 错误检查
        printf("输入有误，请重新输入：");
        scanf("%d",&info);
    }
    switch (info)
    {
        case 0:
            exit_message_info = 1;
            return;
        case 1:
            printf("请输入需要查询的 id：");
            scanf("%d",&info);
            while(info <= 0 || info > NODE){   // 错误检查
                printf("输入有误，请重新输入：");
                scanf("%d",&info);
            }
            printf("名称：%s \n简介：%s \n",ecust[info].name,ecust[info].profile);
            break;
        case 2: // 此处为按照名称查找的大致算法实现。由于中文问题，无法正常执行。
                // 需要后续使用 wchar.h 头文件，wchar_t wstr[] , wprintf, wscanf, wcscmp 等函数进行中文处理。
            printf("请输入需要查询的景点名字：\n");
            char name_temp[30];
            scanf("%s",name_temp);
            for(i = 1;i <= NODE;++i)
            {
                if(strcmp(name_temp,ecust[i].name) == 0)
                {
                    printf("名称：%s \n简介：%s \n",ecust[i].name,ecust[i].profile);
                    system("pause");
                    break;
                }
            }
            if(i > NODE)   // 没找到对应名字的情况
            {
                printf("未找到对应景点！\n");
            }
            break;
        default:
            for(i = 1;i <= NODE;++i)
            {
                printf("id:%d \n名称：%s \n简介：%s \n",ecust[i].id,ecust[i].name,ecust[i].profile);
            }
            break;
    }
}

int stack[NODE + 1],ans[NODE + 1],stack_size,ans_size,ans_dis = 9999;  
// stack,ans 保存最短路径信息，ans_dis 为最短路径
int status[NODE + 1],edge_walked[NODE + 1][NODE + 1],distance;
// status 深搜状态, edge_walked 深搜条件限制， distance 深搜距离
int start,end;  // 开始节点，结束节点
void dfs_init() // 回归初始状态，为了多次查询最小距离
{
    stack_size = 0,ans_size = 0,ans_dis = 9999,distance = 0;
    for (i = 1; i <= NODE; i++) {status[i] = 0;for(j = 1;j <= NODE;++j) edge_walked[i][j] = 0;}
}
void record()       // 搜索到终点时，记录此时的最短路径
{
    if(distance >= ans_dis) return;
    ans_dis = distance;
    for(int i = 1;i <= stack_size;++i)
    {
        ans[i] = stack[i];
    }
    ans_size = stack_size;
}
void dfs(int now)
{
    if(status[now] == 1) return;
    status[now] = 1;
    stack[++stack_size] = now;
    if(now == end)
    {
        record();
        stack_size --;
        status[now] = 0;
        return;
    }
    for(int i = 1;i <= NODE;++i)
    {
        if(edge[now][i] != 9999 && edge_walked[now][i] == 0 && status[i] == 0)
        {
            edge_walked[now][i] = 1;
            distance += edge[now][i];
            dfs(i);
            distance -= edge[now][i];   // 回退
        }
    }
    stack_size --;          // 回退
    status[now] = 0;        // 回退
}
void route_info()   // 查询最短简单路径
{
    exit_message_info = 0;
    printf("路径查询，请输入你需要查询的起点与终点 id，为两个整数，以空格隔开\n");
    scanf("%d%d",&start,&end);
    while(start <= 0 || start > NODE || end <= 0 || end > NODE){   // 错误检查
        printf("输入有误，请重新输入：");
        scanf("%d%d",&start,&end);
    }
    dfs_init();
    dfs(start);
    printf("最短距离为：%d\n路径为： ",ans_dis);
    for(i = 1;i <= ans_size;++i)
    {
        printf("%s ",ecust[ans[i]].name);
    }
    printf("\n");
}
int main()
{
    init();
    while(1){   // 主循环，复用程序
        printf("欢迎来到校园导游咨询。请输入你需要的条目：\n1.信息查询\n2.问路查询\n");
        int info;
        scanf("%d",&info);
        while(info <= 0 || info > 2){   // 错误检查
            printf("输入有误，请重新输入：");
            scanf("%d",&info);
        }
        switch (info)
        {
            case 1:
                while(exit_message_info != 1)
                {
                    message_info();
                }
                break;

            default:
                route_info();
                break;
        }
    }
}