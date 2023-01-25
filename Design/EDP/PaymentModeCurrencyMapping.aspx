<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PaymentModeCurrencyMapping.aspx.cs" Inherits="Design_EDP_PaymentModeCurrencyMapping" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Payment Mode and Currency Mapping</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Department</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlDepartment" onchange="LoadEmployee($(this).find('option:selected').val(),function(){});"></select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Employee</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlEmployee"></select>
                </div>
                <div class="8" style="text-align:center;">
                    <input type="button" id="btnSelect" value="Select" class="ItdoseButton" onclick="binddetail();" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left patientInfo"><b>Department</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <b><label id="lblDepartment" class="patientInfo"></label></b>
                </div>
                <div class="col-md-3">
                    <label class="pull-left patientInfo"><b>Employee</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <b><label id="lblEmployee" class="patientInfo"></label></b>
                    <label id="lblEmployeeID" style="display:none;"></label>
                </div>
                <div class="col-md-3"></div>

            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-18">
                    <div id="SearchOutPut" style="max-height: 250px; overflow-x: auto; display: none;"></div>
                </div>
                <div class="col-md-3"></div>
            </div>
            
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-10"></div>
                <div class="col-md-4"><input type="button" id="btnSave" value="Save" class="ItdoseButton" onclick="SaveMapping()" /></div>
                <div class="col-md-10"></div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var EmployeeID = '<%=Request.QueryString["EmployeeID"]%>';
        $(document).ready(function () {
            LoadRole(function (SelectedROle) {
                LoadEmployee(SelectedROle, function () {
                    BindPaymentMatrix(function () {
                        BindGLCOde(function () {
                        });
                    });
                });
            });
            BindEmployeeDetail();
        });

        var LoadRole = function (callback) {
            serverCall('PaymentModeCurrencyMapping.aspx/LoadRole', {}, function (response) {
                ddlDepartment = $('#ddlDepartment');
                ddlDepartment.bindDropDown({defaultValue:'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoleName', isSearchAble: false });
                callback($('#ddlDepartment').val());
            });
        }
        var LoadEmployee = function (RoleID, callback) {
            //     var RoleID = $('#ddlDepartment option:selected').val();
            serverCall('PaymentModeCurrencyMapping.aspx/LoadEmployee', { RoleID: RoleID }, function (response) {
                ddlEmployee = $('#ddlEmployee');
                ddlEmployee.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Employee_ID', textField: 'Name', isSearchAble: false });
                callback(true);
            });
        }

        function binddetail() {
            if ($('#ddlDepartment option:selected').val() == "0") {
                modelAlert('Please Select Any Department');
                return false;
            }
            if ($('#ddlEmployee option:selected').val() == "0") {
                modelAlert('Please Select Any Employee');
                return false;
            }
            $('#lblDepartment').text($('#ddlDepartment option:selected').text());
            $('#lblEmployee').text($('#ddlEmployee option:selected').text());
            $('#lblEmployeeID').text($('#ddlEmployee option:selected').val());
        }

        var BindGLCOde = function (callback) {
            serverCall('PaymentModeCurrencyMapping.aspx/BindGLCode', {}, function (response) {
                optionData = JSON.parse(response);
                $('[id$=ddlGLCode]').append($("<option></option>").val("0").html("Select"));
                for (var i = 0; i < optionData.length; i++) {

                    $('[id$=ddlGLCode]').append('<option value="' + optionData[i].COA_ID + '">' + optionData[i].COA_NM + '</option>');

                }
                callback(true);
            });
        }
        var BindPaymentMatrix = function (callback) {
            serverCall('PaymentModeCurrencyMapping.aspx/BindPaymentMatrix', {}, function (response) {
                StockData = jQuery.parseJSON(response);
                var output = $('#tb_SearchData').parseTemplate(StockData);
                $('#SearchOutPut').html(output);
                $('#SearchOutPut').show();
                callback(true);
            });
        }


        var BindEmployeeDetail = function () {
            serverCall('PaymentModeCurrencyMapping.aspx/BindEmployeeDetail', { EmployeeID: EmployeeID }, function (response) {
                EmpData = jQuery.parseJSON(response);
                $('#lblDepartment').text(EmpData[0].RoleName);
                $('#lblEmployee').text(EmpData[0].Name);
                $('#lblEmployeeID').text(EmpData[0].Employee_ID);
            });
        }



        var SaveMapping = function () {
            if ($('#lblEmployeeID').text() == "") {
                modelAlert('Please Select Any Employee');
                return false;
            }
            if (Validate()==true) {
                var data = GetDetail();
                serverCall('PaymentModeCurrencyMapping.aspx/SaveMappping', { paymentModeWiseGlobalCodeDetails: data, EmpID: $('#lblEmployeeID').text() }, function (response) {
                    var result = parseInt(response);
                    if (result == 1)
                        modelAlert('Record Save Successfully');
                    else
                        modelAlert('Error Occured');
                });
            }
        }

        var Validate = function () {
            var j = 0;;
            $('#tb_SearchResultData tbody tr').each(function () {
                var selectedRow = this;
                $(selectedRow).find('td:not(:first)').each(function (i, e) {
                    if ($(this).find('select option:selected').val() == "0") {
                      
                        $(this).find('select option:selected').focus();
                         j = 1;
                    }
                });
            });
            if (j == 1) {
                modelAlert('Please Select and Fill the Complete Matrix');
                return false;
            }
            else
                return true;
        }



        var GetDetail = function () {
            var paymentModeWiseGlobalCodeDetail = [];
            $('#tb_SearchResultData tbody tr').each(function () {
                var selectedRow = this;
                var data = {}
                data.currency = $(selectedRow).find('#tdCurrency').text();
                data.globalCodeDetail = [];
                $(selectedRow).find('td:not(:first)').each(function (i, e) {
                 
                    var PMode = $.trim($(this).closest('table').find('thead tr').find('th:eq(' + (i + 1) + ')').text());
                    var d = {
                        value: $(this).find('select option:selected').val(),
                        text: $(this).find('select option:selected').text(),
                        paymentMode: PMode
                    };
                    data.globalCodeDetail.push(d);
                });
                paymentModeWiseGlobalCodeDetail.push(data);
            });
            return paymentModeWiseGlobalCodeDetail;
        }



    </script>

    <script id="tb_SearchData" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_SearchResultData" style="width:100%;border-collapse:collapse;">
        <thead>
            <#  var data=StockData.length;    #>
            <#if(data>0){#>
		    <tr id="trNotifiHeader">
                <th style="max-width:110px;text-align:center !important" class="GridViewHeaderStyle trimText" scope="col" >Currency</th>
            	     <#}#>
	                 <#
					    for(var  key in StockData[0])
						    {
						       if(key.indexOf('_PayMode')>-1)
						    #>          
						       <th class="GridViewHeaderStyle" scope="col"   style="width:115px" >
								   <#=key.split("_")[0]#>
						       </th>    
					    <#}#> 
		    </tr>
        </thead>
         <tbody>
        <#       
        var dataLength=StockData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = StockData[j];
        #>
                <tr id="tr1">            
                    <td class="GridViewLabItemStyle" id="tdCurrency" style="width:50px;" ><#=objRow.Currency#></td> 
                    <#
                    for(var  key in objRow)
						{
						   if(key.indexOf('_PayMode')>-1)
						#>     
                    <td class="GridViewLabItemStyle" style="width:80px;">
                        <select id="ddlGLCode" class="requiredField"></select>
                    </td>
                    <#}#>  
                </tr>           
        <#}#>  
            </tbody>                   
     </table>    
    </script>
</asp:Content>
