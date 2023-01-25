<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CentreWiseMapping.aspx.cs" Inherits="Design_EDP_CentreWiseMapping" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style type="text/css">
        .divBlock {
            /*border-color: black;
            border-width: 1px;*/
            /*border-style: solid;*/
            border: solid 1px #303e54;
            padding-left: 0px;
            padding-right: 0px;
            border-bottom: transparent;
            border-top: transparent;
            border-left: transparent;
        }

        .clearDiv {
            height: 212px;
            overflow: auto;
        }
    </style>



    <script type="text/javascript">

        $(document).ready(function () {
            getAllCentre(function (centreID) {
                getAllMappings(centreID, function () {
                    if ($('#lblselectedcenterid').text() != '')
                    {
                        $('#ddlCentreID').val($('#lblselectedcenterid').text()).change().chosen("destroy").chosen();
                    }
                });
            });
        });



        var onCentreChange = function (el) {
            getAllMappings(el.value, function () {

            });
        }

        var onSelectAll = function (el) {
            $(el).closest('.divBlock').find('.clearDiv').find('input[type=checkbox]').prop('checked', el.checked);
        }

        var onSelectElem = function (el) {
            var allCheckbox = $(el).closest('.divBlock').find('.clearDiv').find('input[type=checkbox]');

            var allCheckedCheckbox = $(el).closest('.divBlock').find('.clearDiv').find('input[type=checkbox]:checked');

            if (allCheckedCheckbox.length == allCheckbox.length)
                $(el).closest('.divBlock').find('.row:first input[type=checkbox]').prop('checked', true);
            else
                $(el).closest('.divBlock').find('.row:first input[type=checkbox]').prop('checked', false);

            if ($(el).closest('.divBlock').find('.clearDiv').attr('id') == 'divRoleMapping')
            {
                bindIndentMappingDetails(1, '');
            }

        }


        var getAllMappings = function (centreID, callback) {
            serverCall('Services/CentreWiseMapping.asmx/GetAllMappings', { centreID: centreID }, function (response) {
                var responseData = JSON.parse(response);

                var divRoleMapping = $('#divRoleMapping');
                templateData = responseData.dtRoles;
                var parseHTML = $('#templateMapping').parseTemplate(templateData);
                divRoleMapping.html(parseHTML);
                var totalChecked=templateData.filter(function(i){ return i.MapID>0 });
                if (templateData.length == totalChecked.length)
                    divRoleMapping.closest('.divBlock').find('.row:first input[type=checkbox]').prop('checked', true);


                var divEmployeeMapping = $('#divEmployeeMapping');
                templateData = responseData.dtEmployees;
                var parseHTML = $('#templateMapping').parseTemplate(templateData);
                divEmployeeMapping.html(parseHTML);
                var totalChecked = templateData.filter(function (i) { return i.MapID > 0 });
                if (templateData.length == totalChecked.length)
                    divEmployeeMapping.closest('.divBlock').find('.row:first input[type=checkbox]').prop('checked', true);


                var divDoctorMapping = $('#divDoctorMapping');
                templateData = responseData.dtDoctors;
                var parseHTML = $('#templateMapping').parseTemplate(templateData);
                divDoctorMapping.html(parseHTML);
                var totalChecked = templateData.filter(function (i) { return i.MapID > 0 });
                if (templateData.length == totalChecked.length)
                    divDoctorMapping.closest('.divBlock').find('.row:first input[type=checkbox]').prop('checked', true);


                var divPanel = $('#divPanel');
                templateData = responseData.dtPanels;
                var parseHTML = $('#templateMapping').parseTemplate(templateData);
                divPanel.html(parseHTML);
                var totalChecked = templateData.filter(function (i) { return i.MapID > 0 });
                if (templateData.length == totalChecked.length)
                    divPanel.closest('.divBlock').find('.row:first input[type=checkbox]').prop('checked', true);

                bindIndentMappingDetails(0,responseData.dtRoles);
                callback(responseData);
            });
        }

        var bindIndentMappingDetails = function (isRoleChecedCheck, responseData) {
            debugger;
            templateData = [];
            if (isRoleChecedCheck == 1) {
                $('#divRoleMapping').find('input[type=checkbox]:checked').each(function () {
                    var tdData = JSON.parse($(this).closest('.row').find('.lblData').text());
                    if (tdData.IsStore == "1") {
                        templateData.push({
                            TextField: tdData.TextField,
                            ValueField: tdData.ValueField,
                            MapID: tdData.MapID,
                            IsPatientIndent: tdData.IsPatientIndent,
                            IsDepartmentIndent: tdData.IsDepartmentIndent
                        });
                    }
                });
            }
            else {

                templateData = responseData.filter(function (i) { return i.MapID > 0 && i.IsStore > 0 });
            }

            var divPatientIndentMapping = $('#divPatientIndentMapping');
            var parseHTML = $('#templateMappingPatientIndent').parseTemplate(templateData);
            divPatientIndentMapping.html(parseHTML);
            var totalChecked = templateData.filter(function (i) { return i.IsPatientIndent > 0 });
            if (templateData.length == totalChecked.length)
                divPatientIndentMapping.closest('.divBlock').find('.row:first input[type=checkbox]').prop('checked', true);


            var divDeptIndentMapping = $('#divDeptIndentMapping');
            var parseHTML = $('#templateMappingDeptIndent').parseTemplate(templateData);
            divDeptIndentMapping.html(parseHTML);
            var totalChecked = templateData.filter(function (i) { return i.IsDepartmentIndent > 0 });
            if (templateData.length == totalChecked.length)
                divDeptIndentMapping.closest('.divBlock').find('.row:first input[type=checkbox]').prop('checked', true);
         
        }







        var getAllCentre = function (callback) {
            serverCall('Services/CentreWiseMapping.asmx/GetAllCentre', {}, function (response) {
                var responseData = JSON.parse(response);
                var ddlCentreID = $('#ddlCentreID');
                ddlCentreID.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                callback(ddlCentreID.val());
            });

        }


        var $searchByWord = function (e) {
            if (e.target.value.length >= 3)
                $('.divBlock .clearDiv').find('.row').show().find('span').not(":containsIgnoreCase('" + e.target.value + "')").closest('.row').hide();
            else if (e.target.value.length == 0)
                $('.divBlock .clearDiv').find('.row').show();
        }


        $.expr[':'].containsIgnoreCase = function (n, i, m) {
            return jQuery(n).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
        };


        var onFilterTypeChange = function (el) {
            var filterType = Number(el.value);
            var txtSearch = $('#txtSearch');
            if (filterType == 0) {
                txtSearch.prop('disabled', false);
                $('.divBlock .clearDiv').find('.row').show();
            }
            else if (filterType == 1) {
                txtSearch.val('').prop('disabled', true);
                $('.divBlock .clearDiv').find('.row').hide();
                $('.divBlock .clearDiv').find('.row input[type=checkbox]:checked').closest('.row').show();
            }
            else if (filterType == 2) {
                txtSearch.val('').prop('disabled', true);
                $('.divBlock .clearDiv').find('.row').show();
                $('.divBlock .clearDiv').find('.row input[type=checkbox]:checked').closest('.row').hide();

            }
        }




        var getMappingDetails = function (callback) {

            var centreID = Number($('#ddlCentreID').val());
            var mappedRoles = [];
            var mappedEmployees = [];
            var mappedDoctors = [];
            var mappedPanels = [];
            var patientIndentMapping = [];
            var deptIndentMapping = [];
            $('#divRoleMapping').find('input[type=checkbox]:checked').each(function () {
                var tdData = JSON.parse($(this).closest('.row').find('.lblData').text());
                mappedRoles.push({
                    centreID: centreID,
                    valueField: tdData.ValueField
                });
            });

            $('#divEmployeeMapping').find('input[type=checkbox]:checked').each(function () {
                var tdData = JSON.parse($(this).closest('.row').find('.lblData').text());
                mappedEmployees.push({
                    centreID: centreID,
                    valueField: tdData.ValueField
                });
            });

            $('#divDoctorMapping').find('input[type=checkbox]:checked').each(function () {
                var tdData = JSON.parse($(this).closest('.row').find('.lblData').text());
                mappedDoctors.push({
                    centreID: centreID,
                    valueField: tdData.ValueField
                });
            });

            $('#divPanel').find('input[type=checkbox]:checked').each(function () {
                var tdData = JSON.parse($(this).closest('.row').find('.lblData').text());
                mappedPanels.push({
                    centreID: centreID,
                    valueField: tdData.ValueField
                });
            });

            $('#divPatientIndentMapping').find('input[type=checkbox]:checked').each(function () {
                var tdData = JSON.parse($(this).closest('.row').find('.lblData').text());
                patientIndentMapping.push({
                    centreID: centreID,
                    valueField: tdData.ValueField
                });
            });
            $('#divDeptIndentMapping').find('input[type=checkbox]:checked').each(function () {
                var tdData = JSON.parse($(this).closest('.row').find('.lblData').text());
                deptIndentMapping.push({
                    centreID: centreID,
                    valueField: tdData.ValueField
                });
            });

            callback({ centreID: centreID, mappedRoles: mappedRoles, mappedEmployees: mappedEmployees, mappedDoctors: mappedDoctors, mappedPanels: mappedPanels, patientIndentMapping: patientIndentMapping, deptIndentMapping: deptIndentMapping });
        }



        var saveMappingDetails = function () {
            getMappingDetails(function (data) {
                serverCall('Services/CentreWiseMapping.asmx/SavesMappingsDetails', data, function (resposne) {
                    var responseData = JSON.parse(resposne);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                    });
                });
            });
        }



    </script>







    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b><span id="lblHeader bold">CentreWise Mapping</span></b>
            <span class="hidden" id="spnHashCode"></span>
            <asp:Label ID="lblselectedcenterid" runat="server" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                select Centre
            </div>


            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Centre Name
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-8">
                            <select id="ddlCentreID" onchange="onCentreChange(this);"></select>
                        </div>


                       

                        <div class="col-md-3">
                             <label class="pull-left">
                                Filter
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-3">
                            <select id="ddlFilterType" onchange="onFilterTypeChange(this);"> 
                                <option value="0">Search</option>
                                <option value="1">All Checked</option>
                                <option value="2"> All UnChecked</option>
                             
                            </select>
                        </div>
                        <div class="col-md-7">
                            <input type="text" id="txtSearch" onkeyup="$searchByWord(event);" />
                        </div>


                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


        </div>


        <div class="POuter_Box_Inventory" style="padding-bottom: 0px;">
            <div class="row" style="margin: 0px;">
                <div class="col-md-8 divBlock" style="border-left: transparent;">
                    <div class="Purchaseheader">
                        Employee
                    </div>

                     <div class="row" style="padding: 0px;margin: 0px;">
                         <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectAll(this)" /><b> All</b> </label>
                   </div>
                    <div id="divEmployeeMapping" class="clearDiv"></div>


                </div>

                <div class="col-md-8 divBlock" style="border-left: transparent;">
                    <div class="Purchaseheader">
                        Doctor
                    </div>
                     <div class="row" style="padding: 0px;margin: 0px;">
                         <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectAll(this)" /><b> All</b> </label>
                   </div>
                    <div id="divDoctorMapping" class="clearDiv"></div>
                </div>

                <div class="col-md-8 divBlock" style="border-left: transparent; border-right: transparent;">
                    <div class="Purchaseheader">
                        Panel
                    </div>
                     <div class="row" style="padding: 0px;margin: 0px;">
                         <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectAll(this)" /><b> All</b> </label>
                   </div>
                    <div id="divPanel" class="clearDiv"></div>
                </div>
            </div>
              <div class="row" style="margin: 0px;">
                 <div class="col-md-8 divBlock">
                    <div class="Purchaseheader">
                        Role
                    </div>
                    <div class="row" style="padding: 0px;margin: 0px;">
                         <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectAll(this)" /><b> All</b> </label>
                   </div>
                    <div id="divRoleMapping" class="clearDiv"></div>
                </div>
                <div class="col-md-8 divBlock" style="border-left: transparent;">
                    <div class="Purchaseheader">
                        Patient Indent
                    </div>

                     <div class="row" style="padding: 0px;margin: 0px;">
                         <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectAll(this)" /><b> All</b> </label>
                   </div>
                    <div id="divPatientIndentMapping" class="clearDiv"></div>


                </div>

                <div class="col-md-8 divBlock" style="border-left: transparent;">
                    <div class="Purchaseheader">
                        Department Indent
                    </div>
                     <div class="row" style="padding: 0px;margin: 0px;">
                         <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectAll(this)" /><b> All</b> </label>
                   </div>
                    <div id="divDeptIndentMapping" class="clearDiv"></div>
                </div>
            </div>

        </div>


        <div class="POuter_Box_Inventory textCenter">
            <input type="button" id="btnSave" value="Save" class="save margin-top-on-btn" onclick="saveMappingDetails(this)" />
        </div>

    </div>




        <script id="templateMapping" type="text/html">

         
	
		<#
		var dataLength=templateData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
		for(var j=0;j<dataLength;j++)
		{
		objRow = templateData[j];
		#>
			
            
            <div class="row" style="padding: 0px;margin: 0px;">
              <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectElem(this)"
                  
                  <#if(objRow.MapID>0){#>
                       checked
                  <#}#>
                   /><span>  <#=objRow.TextField#></span> </label>
                <label class="hidden lblData"> <#= JSON.stringify(objRow) #></label>
            </div>
            	
		<#}#>     
	</script>
    <script id="templateMappingPatientIndent" type="text/html">
		<#
		var dataLength=templateData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
		for(var j=0;j<dataLength;j++)
		{
		objRow = templateData[j];
		#>
			
            
            <div class="row" style="padding: 0px;margin: 0px;">
              <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectElem(this)"
                  
                  <#if(objRow.IsPatientIndent>0 ){#>
                       checked
                  <#}#>
                   /><span>  <#=objRow.TextField#></span> </label>
                <label class="hidden lblData"> <#= JSON.stringify(objRow) #></label>
            </div>
            	
		<#}#>     
	</script>
    <script id="templateMappingDeptIndent" type="text/html">
		<#
		var dataLength=templateData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
		for(var j=0;j<dataLength;j++)
		{
		objRow = templateData[j];
		#>
			
            
            <div class="row" style="padding: 0px;margin: 0px;">
              <label style="cursor:pointer"> <input type="checkbox" onchange="onSelectElem(this)"
                  
                  <#if(objRow.IsDepartmentIndent>0 ){#>
                       checked
                  <#}#>
                   /><span>  <#=objRow.TextField#></span> </label>
                <label class="hidden lblData"> <#= JSON.stringify(objRow) #></label>
            </div>
            	
		<#}#>     
	</script>

</asp:Content>

