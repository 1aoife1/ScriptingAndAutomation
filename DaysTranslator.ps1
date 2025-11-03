function daysTranslator($table) {

    foreach ($row in $table) {
        $row.Days = $row.Days -replace 'M', 'Monday ' `
                                -replace 'T', 'Tuesday ' `
                                -replace 'W', 'Wednesday ' `
                                -replace 'H', 'Thursday ' `
                                -replace 'F', 'Friday ' `
                                -replace 'S', 'Saturday ' `
                                -replace 'U', 'Sunday '
    }
    return $table
}
