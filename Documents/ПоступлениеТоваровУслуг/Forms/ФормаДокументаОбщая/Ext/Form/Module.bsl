﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПИН_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПараметрыКорзины") Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперацииПриОткрытии = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия;
	Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия;
	Объект.Склад = Параметры.Склад;
	Объект.ТипЦен = Параметры.ТипЦен;
	ПараметрыКорзины = Параметры.ПараметрыКорзины;
	Если ПараметрыКорзины.Свойство("АдресКорзиныВХранилище") И ЗначениеЗаполнено(ПараметрыКорзины.АдресКорзиныВХранилище) Тогда
		ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(ПараметрыКорзины.АдресКорзиныВХранилище);
		ТаблицаТовары = ТаблицаДляЗагрузки.Скопировать(Новый Структура("Услуга", Ложь));
		Объект.Товары.Загрузить(ТаблицаТовары);
		ТаблицаУслуги = ТаблицаДляЗагрузки.Скопировать(Новый Структура("Услуга", Истина));
		Объект.Услуги.Загрузить(ТаблицаУслуги);
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из Объект.Товары Цикл
		ПриИзмененииНоменклатурыТовары(СтрокаТаблицы);
	КонецЦикла;
	Для Каждого СтрокаТаблицы Из Объект.Услуги Цикл
		ПриИзмененииНоменклатурыУслуги(СтрокаТаблицы);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ИзменениеНоменклатуры

&НаСервере
Процедура ПриИзмененииНоменклатурыУслуги(СтрокаТаблицы)

	// Получим общие параметры обработки для реквизитов документа
	ПараметрыОбработки = ПИН_ПодготовитьПараметрыОбработкиУслугиНоменклатураПриИзменении(
		ЭтаФорма, СтрокаТаблицы);
	
	// Дополнительные поля, требующиеся для заполнения добавленных колонок табличного поля текущей формы.
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("ПодразделениеЗатратДоступность", СтрокаТаблицы.ПодразделениеЗатратДоступность);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("Всего", СтрокаТаблицы.Всего);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("Субконто1Доступность", СтрокаТаблицы.Субконто1Доступность);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("Субконто2Доступность", СтрокаТаблицы.Субконто2Доступность);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("Субконто3Доступность", СтрокаТаблицы.Субконто3Доступность);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("СубконтоНУ1Доступность", СтрокаТаблицы.СубконтоНУ1Доступность);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("СубконтоНУ2Доступность", СтрокаТаблицы.СубконтоНУ2Доступность);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("СубконтоНУ3Доступность", СтрокаТаблицы.СубконтоНУ3Доступность);
	
	ЗаполнитьПараметрыОбъектаДляЗаполненияДобавленныхКолонок(ЭтаФорма, ПараметрыОбработки.ДанныеОбъекта);
		
	УслугиНоменклатураПриИзмененииНаСервере(
		ПараметрыОбработки.ДанныеСтрокиТаблицы,
		ПараметрыОбработки.ДанныеОбъекта,
		ПараметрыОбработки.СчетаУчетаКЗаполнению);
	
	ИсключаемыеПоля = "";
	Если СтрокаТаблицы.Цена <> 0 Тогда
		ИсключаемыеПоля = "Цена, Сумма, СуммаНДС, Всего";
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыОбработки.ДанныеСтрокиТаблицы,,ИсключаемыеПоля);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииНоменклатурыТовары(СтрокаТаблицы)

	// Получим общие параметры обработки для реквизитов документа
	ПараметрыОбработки = ПИН_ПодготовитьПараметрыОбработкиТоварыНоменклатураПриИзменении(ЭтаФорма, СтрокаТаблицы);
	
	// Дополнительные поля, добавленные в табличное поле текущей формы.
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("Всего", СтрокаТаблицы.Всего);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("СчетУчетаЗабалансовый", СтрокаТаблицы.СчетУчетаЗабалансовый);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("ПродукцияМаркируемаяДляГИСМ", СтрокаТаблицы.ПродукцияМаркируемаяДляГИСМ);
	
	ЗаполнитьПараметрыОбъектаДляЗаполненияДобавленныхКолонок(ЭтаФорма, ПараметрыОбработки.ДанныеОбъекта);
		
	ТоварыНоменклатураПриИзмененииНаСервере(
		ПараметрыОбработки.ДанныеСтрокиТаблицы,
		ПараметрыОбработки.ДанныеОбъекта,
		ПараметрыОбработки.СчетаУчетаКЗаполнению);
		
	ИсключаемыеПоля = "";
	Если СтрокаТаблицы.Цена <> 0 Тогда
		ИсключаемыеПоля = "Цена, Сумма, СуммаНДС, Всего";
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыОбработки.ДанныеСтрокиТаблицы,,ИсключаемыеПоля);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПИН_ПодготовитьПараметрыОбработкиТоварыНоменклатураПриИзменении(Форма, СтрокаТабличнойЧасти)
	
	Объект = Форма.Объект;
	
	РассчитыватьСуммаВРознице 	= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "РассчитыватьСуммаВРознице");
	НТТ 						= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "НТТ");
	УчетВПродажныхЦенах 		= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "УчетВПродажныхЦенах");
	РазделениеПоСтавкамВРознице = ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "РазделениеПоСтавкамВРознице");	
	ЭтоКомиссия					= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ЭтоКомиссия");
	ПрименяютсяСтавки4и2		= ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ПрименяютсяСтавки4и2");
	ПоставщикРезидентТаможенногоСоюза = ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ПоставщикРезидентТаможенногоСоюза");
	ВидАгентскогоДоговора = ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ВидАгентскогоДоговора");
	УчетАгентскогоНДС = ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "УчетАгентскогоНДС");
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, ЕдиницаИзмерения, Коэффициент, Количество,
		|Цена, Сумма, СтавкаНДС, СуммаНДС,
		|НадписьПоДокументу, КоличествоПоДокументу, СуммаПоДокументу, СуммаНДСПоДокументу, ЦенаПоДокументу, ВсегоПоДокументу,
		|НадписьОтклонение, КоличествоОтклонение, СуммаОтклонение,  СуммаНДСОтклонение, ЦенаОтклонение, ВсегоОтклонение, 
		|НадписьПоФакту, НомерГТД, СтранаПроисхождения,
		|ЦенаВРознице, СуммаВРознице, СтавкаНДСВРознице,
		|ОтражениеВУСН, МаркируемаяПродукцияГосИС,
		|ПродукцияМаркируемаяДляГИСМ,
		|СчетУчета,СчетУчетаНДС,СпособУчетаНДС");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, ВидОперации, Организация, Склад, ТипЦен, СуммаВключаетНДС,
		|ВалютаДокумента, КурсВзаиморасчетов, КратностьВзаиморасчетов, ЕстьРасхождения,
		|РассчитыватьСуммаВРознице, ЗаполнятьСтавкуНДСВРознице, ЭтоКомиссия,
		|ДоговорКонтрагента, ПрименяютсяСтавки4и2, СпособЗаполненияСтавкиНДС,
		|УчетАгентскогоНДС, ВидАгентскогоДоговора, ПоставщикРезидентТаможенногоСоюза");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.РассчитыватьСуммаВРознице  = РассчитыватьСуммаВРознице;
	ДанныеОбъекта.ЗаполнятьСтавкуНДСВРознице = НТТ И УчетВПродажныхЦенах И РазделениеПоСтавкамВРознице;
	ДанныеОбъекта.ЭтоКомиссия                = ЭтоКомиссия;
	ДанныеОбъекта.ПрименяютсяСтавки4и2       = ПрименяютсяСтавки4и2;
	ДанныеОбъекта.ПоставщикРезидентТаможенногоСоюза = ПоставщикРезидентТаможенногоСоюза;
	ДанныеОбъекта.ВидАгентскогоДоговора       = ВидАгентскогоДоговора;
	ДанныеОбъекта.УчетАгентскогоНДС       = УчетАгентскогоНДС;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку") Тогда
		ДанныеОбъекта.Вставить("СтавкаНДС", ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС"));
	КонецЕсли;
	
	Если Объект.НДСНеВыделять Тогда
		ДанныеОбъекта.Вставить("СтавкаНДС", ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС"));
		ДанныеОбъекта.Вставить("СуммаВключаетНДС", Истина);
	КонецЕсли;
	
	ПараметрыЗаполненияСчетовУчета = ПоступлениеТоваровУслугФормыКлиентСервер.НачатьЗаполнениеСчетовУчета(
		"Товары.Номенклатура",
		Объект,
		СтрокаТабличнойЧасти,
		ДанныеОбъекта,
		ДанныеСтрокиТаблицы);
	
	ПараметрыОбработки = Новый Структура();
	ПараметрыОбработки.Вставить("ДанныеСтрокиТаблицы", 	 ДанныеСтрокиТаблицы);
	ПараметрыОбработки.Вставить("ДанныеОбъекта", 		 ДанныеОбъекта);
	ПараметрыОбработки.Вставить("СчетаУчетаКЗаполнению", ПараметрыЗаполненияСчетовУчета.КЗаполнению);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПИН_ПодготовитьПараметрыОбработкиУслугиНоменклатураПриИзменении(Форма, СтрокаТабличнойЧасти)
	
	Объект = Форма.Объект;
	
	ДанныеСтрокиТаблицы = Новый Структура("Номенклатура, Содержание, Количество, Цена, Сумма, СтавкаНДС, СуммаНДС, ОтражениеВУСН, 
		|НадписьПоДокументу, КоличествоПоДокументу, СуммаПоДокументу, СуммаНДСПоДокументу, ЦенаПоДокументу, ВсегоПоДокументу,
		|НадписьОтклонение, КоличествоОтклонение, СуммаОтклонение, СуммаНДСОтклонение, ЦенаОтклонение, ВсегоОтклонение, НадписьПоФакту,
		|СпособУчетаНДС, СчетУчета, СчетУчетаНДС, СчетЗатрат, Субконто1, Субконто2, Субконто3, 
		|СчетЗатратНУ, СубконтоНУ1, СубконтоНУ2, СубконтоНУ3, ПодразделениеЗатрат, ОтражениеВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);

	ДанныеОбъекта = Новый Структура("Ссылка, Дата, ВидОперации, Организация, ДеятельностьНаПатенте,
		|Склад, ТипЦен, ВалютаДокумента, КурсВзаиморасчетов, КратностьВзаиморасчетов,
		|СуммаВключаетНДС, ДоговорКонтрагента,
		|ЭтоКомиссия, Реализация, ДокументБезНДС");
	ДанныеОбъекта.ЭтоКомиссия = ПоступлениеТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ЭтоКомиссия");
	ДанныеОбъекта.Реализация = Ложь;
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	Если Объект.НДСНеВыделять Тогда
		ДанныеОбъекта.Вставить("СтавкаНДС", ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС"));
		ДанныеОбъекта.Вставить("СуммаВключаетНДС", Истина);
	КонецЕсли;
	
	ПараметрыЗаполненияСчетовУчета = ПоступлениеТоваровУслугФормыКлиентСервер.НачатьЗаполнениеСчетовУчета(
		"Услуги.Номенклатура",
		Объект,
		СтрокаТабличнойЧасти,
		ДанныеОбъекта,
		ДанныеСтрокиТаблицы);
	
	ПараметрыОбработки = Новый Структура();
	ПараметрыОбработки.Вставить("ДанныеСтрокиТаблицы", 	 ДанныеСтрокиТаблицы);
	ПараметрыОбработки.Вставить("ДанныеОбъекта", 		 ДанныеОбъекта);
	ПараметрыОбработки.Вставить("СчетаУчетаКЗаполнению", ПараметрыЗаполненияСчетовУчета.КЗаполнению);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

#КонецОбласти