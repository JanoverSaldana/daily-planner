$baseDir = "c:\Users\janov\Desktop\develop\daily-planner\2025"

# Definir todas las semanas restantes del año 2025
$weeks = @(
    @{Month="10-Octubre"; Start="13-10"; End="19-10"; Title="13 al 19 de Octubre 2025"},
    @{Month="10-Octubre"; Start="20-10"; End="26-10"; Title="20 al 26 de Octubre 2025"},
    @{Month="10-Octubre"; Start="27-10"; End="02-11"; Title="27 de Octubre al 02 de Noviembre 2025"},
    
    @{Month="11-Noviembre"; Start="03-11"; End="09-11"; Title="03 al 09 de Noviembre 2025"},
    @{Month="11-Noviembre"; Start="10-11"; End="16-11"; Title="10 al 16 de Noviembre 2025"},
    @{Month="11-Noviembre"; Start="17-11"; End="23-11"; Title="17 al 23 de Noviembre 2025"},
    @{Month="11-Noviembre"; Start="24-11"; End="30-11"; Title="24 al 30 de Noviembre 2025"},
    
    @{Month="12-Diciembre"; Start="01-12"; End="07-12"; Title="01 al 07 de Diciembre 2025"},
    @{Month="12-Diciembre"; Start="08-12"; End="14-12"; Title="08 al 14 de Diciembre 2025"},
    @{Month="12-Diciembre"; Start="15-12"; End="21-12"; Title="15 al 21 de Diciembre 2025"},
    @{Month="12-Diciembre"; Start="22-12"; End="28-12"; Title="22 al 28 de Diciembre 2025"},
    @{Month="12-Diciembre"; Start="29-12"; End="04-01"; Title="29 de Diciembre 2025 al 04 de Enero 2026"}
)

$template = @"
# Planificador Semanal - {TITLE}

## 🗓️ Resumen de la Semana

**Semana:** {WEEK_RANGE}  

## 📅 Lunes {MONDAY}

### ✅ Tareas del día
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

### 📝 Notas
-

---

## 📅 Martes {TUESDAY}

### ✅ Tareas del día
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

### 📝 Notas
- 


---

## 📅 Miércoles {WEDNESDAY}

### ✅ Tareas del día
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

### 📝 Notas
- 


---

## 📅 Jueves {THURSDAY}

### ✅ Tareas del día
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

### 📝 Notas
- 



---

## 📅 Viernes {FRIDAY}

### ✅ Tareas del día
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

### 📝 Notas
- 



---

## 📅 Sábado {SATURDAY}

### ✅ Tareas del día
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

### 📝 Notas
- 



---

## 📅 Domingo {SUNDAY}

### ✅ Tareas del día
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

### 📝 Notas
- 



---

## 📊 Revisión Semanal

### ✅ Logros de la semana
- [ ] 
- [ ] 
- [ ] 

### 📈 Áreas de mejora
- 
- 
- 
"@

# Función para calcular fechas de la semana
function Get-WeekDates {
    param($startDateStr, $endDateStr)
    
    # Parsear fechas manualmente para el formato DD-MM
    $startParts = $startDateStr.Split('-')
    $endParts = $endDateStr.Split('-')
    
    $startDay = [int]$startParts[0]
    $startMonth = [int]$startParts[1]
    
    $endDay = [int]$endParts[0]
    $endMonth = [int]$endParts[1]
    
    # Asumimos año 2025 para start, 2026 si el mes es enero y estamos en diciembre
    $startYear = if ($startMonth -eq 1 -and $endMonth -eq 12) { 2026 } else { 2025 }
    $endYear = if ($endMonth -eq 1 -and $startMonth -eq 12) { 2026 } else { 2025 }
    
    try {
        $startDate = Get-Date -Year $startYear -Month $startMonth -Day $startDay
        $dates = @()
        
        for ($i = 0; $i -lt 7; $i++) {
            $currentDate = $startDate.AddDays($i)
            $dates += $currentDate.ToString("dd 'de' MMMM", [System.Globalization.CultureInfo]::CreateSpecificCulture("es-ES"))
        }
        
        return $dates
    } catch {
        # Si hay error en las fechas, usar placeholders
        return @("DD de Mes", "DD de Mes", "DD de Mes", "DD de Mes", "DD de Mes", "DD de Mes", "DD de Mes")
    }
}

foreach ($week in $weeks) {
    $weekDates = Get-WeekDates $week.Start $week.End
    
    $content = $template
    $content = $content -replace '{TITLE}', $week.Title
    $content = $content -replace '{WEEK_RANGE}', "$($week.Start) - $($week.End)"
    $content = $content -replace '{MONDAY}', $weekDates[0]
    $content = $content -replace '{TUESDAY}', $weekDates[1]
    $content = $content -replace '{WEDNESDAY}', $weekDates[2]
    $content = $content -replace '{THURSDAY}', $weekDates[3]
    $content = $content -replace '{FRIDAY}', $weekDates[4]
    $content = $content -replace '{SATURDAY}', $weekDates[5]
    $content = $content -replace '{SUNDAY}', $weekDates[6]
    
    $filePath = Join-Path $baseDir $week.Month "$($week.Start) hasta $($week.End).md"
    
    # Crear el archivo
    $content | Out-File -FilePath $filePath -Encoding UTF8
    
    Write-Host "Creado: $filePath"
}

Write-Host "¡Todos los archivos de planificación han sido creados!"
