package com.mooc.backend.schedules;

import com.mooc.backend.repositories.PageEntityRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.annotation.Schedules;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;

@Slf4j
@RequiredArgsConstructor
//@Component
public class ScheduledTasks {
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
    private final PageEntityRepository pageEntityRepository;

    /**
     * 每 5 秒执行一次
     * 这个是最简单的，你可以在控制台看到的定时任务，仅为了演示
     * <p>
     * 下面的 fixRate = 5000 等同于 cron = "0/5 * * * * ?"
     */
    @Scheduled(fixedRate = 5000)
    public void reportCurrentTime() {
        log.debug("The time is now {}", dateFormat.format(System.currentTimeMillis()));
    }

    /**
     * cron 表达式的规则如下
     * 字段 允许值 允许的特殊字符
     * 秒 0-59 , - * /
     * 分 0-59 , - * /
     * 小时 0-23 , - * /
     * 日期 1-31 , - * ? / L W C
     * 月份 1-12 或者 JAN-DEC , - * /
     * 星期 1-7 或者 SUN-SAT , - * ? / L C #
     * 年（可选） 留空, 1970-2099 , - * /
     * <p>
     * "0 0 0 * * ?" 每天凌晨 0 点执行一次
     * "0 0 3 1 * ?" 每月 1 号凌晨 3 点执行一次
     * "0 0 6 1 1 ?" 每年 1 月 1 号凌晨 6 点执行一次
     * "0 0 9 * * 1" 每周一早上 9 点执行一次
     * "0 0 0 1 * 1" 每月第一个周一凌晨 0 点执行一次
     * <p>
     * 其中 '*' 表示匹配该字段的任意值，'?' 表示不指定值
     * '/' 用于指定数值的增量，例如在秒的字段上设置 "0/15" 表示每 15 秒执行一次
     * '-' 用于指定数值的范围，例如在分钟的字段上设置 "10-12" 表示 10, 11, 12 分执行一次
     * ',' 用于指定多个值，例如在星期字段上设置 "MON,WED,FRI" 表示 星期一、三、五 执行一次
     * 'L' 用于表示在某个字段的最后一个，例如在星期字段上设置 "L" 表示在这个月的最后一个星期日执行一次
     * 'W' 用于表示离指定日期的最近那个工作日（周一到周五），例如在日期字段上设置 "15W" 表示离每月 15 号最近的那个工作日执行一次
     * 'LW' 组合在一起表示在某个月的最后一个工作日，例如在日期字段上设置 "LW" 表示在这个月的最后一个工作日执行一次
     * '#' 用于确定每个月第几个星期几，例如在星期字段上设置 "6#3" 表示每个月的第三个星期五
     */
    @Transactional
    @Schedules({
            @Scheduled(cron = "0 0 2 * * 1"), // 每周一凌晨 2 点执行一次
            @Scheduled(cron = "0 0 3 * * 4"), // 每周四凌晨 3 点执行一次
    })
    public void checkOverduePageAndArchive() {
        log.debug("checkOverduePageAndArchive");
        var now = LocalDateTime.now();
        pageEntityRepository.updatePageStatusToArchived(now);
    }
}
