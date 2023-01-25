<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ApprovalTypeMaster.aspx.cs" Inherits="Design_EDP_ApprovalTypeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Discount Approval Type Master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
                <input id="rdoNew" type="radio" name="Con" value="New" checked="checked">New
           <input id="rdoEdit" type="radio" name="Con" value="Edit">Edit    
            </div>

        </div>
        <div class="POuter_Box_Inventory">
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtName" tabindex="1" maxlength="50" title="Enter Name" class="requiredField" />
                            </div>
                         <div class="col-md-4">
                            <label class="pull-left">
                                Responsible Employee
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlEmployee" class="requiredField"></select>
                            </div>
                      </div>
                    <div class="row trCondition" style="display:none;">
                         <div class="col-md-4">
                            <label class="pull-left">
                                Condition
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                           <div class="col-md-5">
                                <input id="rdoActive" type="radio" name="ActiveCon" value="1" checked="checked" />Active
                        <input id="rdoDeActive" type="radio" name="ActiveCon" value="0" />DeActive  
                         <input id="rdoBoth" type="radio" name="ActiveCon" value="2" />Both 
                               </div>
                        </div>
                    </div>
                 </div>
           </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" />
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;display:none;" id="divSearch">
             <div class="Purchaseheader">
                Search Results
            </div>
         <div id="DisAppovalOutput" style="max-height: 500px; overflow-x: auto;">
        </div>
             <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display:none"/>
             </div>
    </div>
    <script type="text/javascript">
        function chkActiveCon(rowid) {
            $("#spnErrorMsg").text('');
            var rdotdActive = $(rowid).closest('tr').find('#tdActive input[type=radio]:checked').val();
            var spnActive = $.trim($(rowid).closest('tr').find('#spnActive').html());
            if (rdotdActive != spnActive) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('1'));
                $(rowid).closest('tr').find('#spnActiveCon').addClass("ChangeActive");
            }
            else if (($.trim($(rowid).closest('tr').find('#spnApprovalTypeCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
                $(rowid).closest('tr').find('#spnActiveCon').removeClass("ChangeActive");

            }
            else {
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
                $(rowid).closest('tr').find('#spnActiveCon').removeClass("ChangeActive");
            }
        }
        function CheckApp(rowid) {
            $("#spnErrorMsg").text('');
            var txtApprovalType = $.trim($(rowid).closest('tr').find('#txtApprovalType').val());
            var spnApprovalType = $.trim($(rowid).closest('tr').find('#spnApprovalType').html());
            if ((txtApprovalType != spnApprovalType)) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnApprovalTypeCon').html('1'));
                $(rowid).closest('tr').find('#spnActiveCon').addClass("ChangeApp");
            }
            else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnApprovalTypeCon').html('0'));
                $(rowid).closest('tr').find('#spnActiveCon').removeClass("ChangeApp");
            }
            else if ($(rowid).closest('tr').find('#spnEmpId').text() != $(rowid).closest('tr').find('#ddlEditEmployee').val()) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnApprovalTypeCon').html('1'));
                $(rowid).closest('tr').find('#spnActiveCon').addClass("ChangeApp");

            }
            else {
                $.trim($(rowid).closest('tr').find('#spnApprovalTypeCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
                $(rowid).closest('tr').find('#spnActiveCon').removeClass("ChangeApp");
            }
        }
        function bindApproval() {
            var type = "";
            if ($("#rdoActive").is(':checked'))
                type = "1";
            else if ($("#rdoDeActive").is(':checked'))
                type = "0";
            else
                type = "2";

            $.ajax({
                url: "services/EDP.asmx/bindDisAppoval",
                data: '{ApprovalType:"' + $("#txtName").val() + '",Type:"' + type + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        DisAppoval = jQuery.parseJSON(result.d);
                        if (DisAppoval != null) {
                            var output = $('#tb_DisAppovalSearch').parseTemplate(DisAppoval);
                            $('#DisAppovalOutput').html(output);
                            bindEditEmployee();
                            $('#DisAppovalOutput,#btnUpdate').show();
                            $('#btnSave').removeProp('disabled');
                            $('#divSearch').show();

                        }
                    }
                    else {
                        $('#DisAppovalOutput').html();
                        $('#DisAppovalOutput,#btnUpdate').hide();
                        DisplayMsg('MM04', 'spnErrorMsg');
                        $('#btnSave').removeProp('disabled');
                        $('#divSearch').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#DisAppovalOutput').html();
                    $('#DisAppovalOutput').hide();
                    DisplayMsg('MM05', 'spnErrorMsg');
                }
            });
        }
        $(function () {
            $("#txtName").focus();
            if ($("#rdoNew").is(':checked')) {
                $("#btnSave").val('Save');
            }
            if ($("#rdoEdit").is(':checked')) {
                $("#btnSave").val('Search');
            }

            $("#rdoNew").bind("click", function () {
                $("#btnSave").val('Save');
                $(".trCondition").hide();
                $("#spnErrorMsg").text('');
                hideAllDetail();
            });
            $("#rdoEdit").bind("click", function () {
                $("#btnSave").val('Search');
                $(".trCondition").show();
                $("#spnErrorMsg").text('');
                hideAllDetail();
            });
            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnSave').attr('disabled', 'disabled');
                if ($("#btnSave").val() == "Search") {
                    bindApproval();
                }
                else if ($("#btnSave").val() == "Save") {
                    saveDiscountApproval();
                }
            });
            getEmployee(function (Emp) {
                $('#ddlEmployee').bindDropDown({ defaultValue: 'Select', data: Emp, valueField: 'EMP_ID', textField: 'Name', isSearchAble: true });

            });
        });

        function hideAllDetail() {
            $('#DisAppovalOutput').html('');
            $('#DisAppovalOutput,#btnUpdate').hide();

        }
        function getEmployee(callback) {
            serverCall('ApprovalTypeMaster.aspx/getEmployeeList', {}, function (response) {
                EmpList = JSON.parse(response);
                callback(EmpList);
            });
        }
        function bindEditEmployee() {
            $('#tb_grdDisAppovalSearch tr:not(#Header)').each(function () {
                $(this).find('#ddlEditEmployee').bindDropDown({ data: EmpList, valueField: 'EMP_ID', textField: 'Name', isSearchAble: false });
                $(this).find('#ddlEditEmployee').val($(this).find('#spnEmpId').text());
            });


        }
    </script>
            <script id="tb_DisAppovalSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdDisAppovalSearch"
    style="width:900px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Name</th> 
            <th class="GridViewHeaderStyle" scope="col" >Resp. Employee</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
		</tr>
        <#       
        var dataLength=DisAppoval.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = DisAppoval[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:40px;display:none" ><#=objRow.ID#></td>                  
                    <td class="GridViewLabItemStyle" id="tdName" style="width:200px;">
                       <input type="text" maxlength="50" style="width:280px" value="<#=objRow.ApprovalType#>" id="txtApprovalType" onkeyup="CheckApp(this);" onkeypress="CheckApp(this);" class="requiredField"/>
                       <span id="spnApprovalType" style="display:none" ><#=objRow.ApprovalType#> </span>
                       <span id="spnApprovalTypeCon"  style="display:none" /></td> 
                         <td class="GridViewLabItemStyle" style="width:200px;">
                             <select id="ddlEditEmployee" class="requiredField" onchange="CheckApp(this)"></select>
                             <span id="spnEmpId" style="display:none;"><#=objRow.EmployeeID#></span>
                             </td>
                                                                       
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:60px;">
                   <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"
                      onclick="chkActiveCon(this)"    <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #> />Yes                         
                         <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0"
                        onclick="chkActiveCon(this)" <#if(objRow.IsActive=="0"){#> 
                        checked="checked"  <#} #>  />No                                               
                        <span id="spnActive" style="display:none"><#=objRow.IsActive#></span>
                         <span id="spnActiveCon" style="display:none"   />
                    </td>
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <script type ="text/javascript">
        $(function () {
            $("#btnUpdate").bind("click", function () {
                $('#btnUpdate').attr('disabled', 'disabled');
                if (validateDisApprovalUpdate() == true) {
                    var resultAppUpdate = appUpdate();
                    $.ajax({
                        url: "Services/EDP.asmx/UpdateApprovalType",
                        data: JSON.stringify({ Data: resultAppUpdate }),
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                                DisplayMsg('MM02', 'spnErrorMsg');
                                $('#btnUpdate').removeAttr('disabled');
                                $('#DisAppovalOutput').html('');
                                $('#DisAppovalOutput,#btnUpdate,.trCondition').hide();
                                $('#rdoActive').prop('checked', 'checked');
                                $('#rdoNew').prop('checked', 'checked');
                                $("#btnSave").val('Save');
                                hideAllDetail();
                            }
                            else if (result.d == "2") {
                                $("#spnErrorMsg").text('Discount Approval Already Exist');
                                $('#btnUpdate').removeAttr('disabled');
                            }
                            else {
                                DisplayMsg('MM05', 'spnErrorMsg');
                            }

                        },
                        error: function (xhr, status) {
                            DisplayMsg('MM05', 'spnErrorMsg');
                        }
                    });
                }
                else {
                    $('#btnUpdate').removeProp('disabled');
                }
            });

        });
        function appUpdate() {
            if ($('#tb_grdDisAppovalSearch tr').length > 0) {
                var con = 0;
                // $('#btnUpdate').prop('disabled', 'disabled');
                var dataItem = new Array();
                var ObjItem = new Object();
                $(".ChangeActive,.ChangeApp").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        if (($.trim($rowid.find('#spnApprovalTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                            ObjItem.ApprovalType = $.trim($rowid.find("#txtApprovalType").val());
                            ObjItem.ID = $.trim($rowid.find("#tdID").text());
                            if ($rowid.find("#rdotdActive").is(':checked'))
                                ObjItem.IsActive = "1";
                            else
                                ObjItem.IsActive = "0";

                            ObjItem.EmpId = $.trim($rowid.find('#ddlEditEmployee').val());

                            dataItem.push(ObjItem);
                            ObjItem = new Object();
                        }
                    }

                });
                return dataItem;
            }
        }
        function validateDisApprovalUpdate() {
            var con = 0; var tableCon = 1;
            $("#tb_grdDisAppovalSearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") {
                    if (($.trim($rowid.find('#spnApprovalTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                        if ($.trim($rowid.find("#txtApprovalType").val()) == "") {
                            $("#spnErrorMsg").text('Please Enter Discount Approval Name');
                            $rowid.find("#txtApprovalType").focus();
                            con = 1;
                            return false;
                        }
                        tableCon += 1;
                    }
                }

            });
            if (con == "1")
                return false;
            if (tableCon == "1") {
                $("#spnErrorMsg").text('Please Change Discount Approval OR Employee OR Active Condition');
                return false;
            }
            return true;
        }
        function saveDiscountApproval() {
            if (validateApproval() == true) {

                $.ajax({
                    url: "Services/EDP.asmx/saveDiscountApproval",
                    data: '{ApprovalType:"' + $.trim($('#txtName').val()) + '",EmpId:"' + $('#ddlEmployee').val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Saved Successfully');
                            $('#txtName').val('');
                            $("#btnSave").removeProp('disabled');
                        }
                        else if (result.d == "2") {
                            $("#spnErrorMsg").text('Discount Approval Already Exist');
                            $('#txtName').focus();
                            $("#btnSave").removeProp('disabled');
                        }

                        else {
                            DisplayMsg('MM05', 'spnErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'spnErrorMsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                $('#btnSave').removeProp('disabled');
            }
        }

        function validateApproval() {
            if ($.trim($('#txtName').val()) == "") {
                modelAlert('Please Enter Discount Approval Name', function () {
                    $('#txtName').focus();
                });
                return false;
            }
            if ($('#ddlEmployee').val() == '0') {
                modelAlert('Please Select Employee', function () {
                    $('#ddlEmployee').focus();
                });
                return false;
            }
            return true;
        }
    </script>
</asp:Content>

