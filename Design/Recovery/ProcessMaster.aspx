<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ProcessMaster.aspx.cs" Inherits="Design_Recovery_ProcessMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">   
    
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Recovery Process Master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
                <input id="rdoNew" type="radio" name="Con" value="New" checked="checked" />New
                <input id="rdoEdit" type="radio" name="Con" value="Edit" />Edit    
            </div>
        </div>


        <div class="POuter_Box_Inventory">
            <table style="width: 100%; border-collapse: collapse">              
                <tr>
                    <td style="width: 15%; text-align: right">Process Name :&nbsp;
                        
                    </td>
                    <td style="width: 30%; text-align: left">
                        <input type="text" id="txtProcess" tabindex="3" maxlength="100" title="Enter Process Name" style="width: 250px" class="requiredField" />
                    </td>
                    <td style="width: 15%; text-align: right">&nbsp;
                    </td>
                    <td style="width: 45%; text-align: left">
                       &nbsp;
                    </td>
                </tr>
                <tr class="trCondition" style="display:none">
                    <td style="width: 15%; text-align: right;" >Condition :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left;" >
                       <input id="rdoActive" type="radio" name="ActiveCon" value="1" checked="checked" />Active
                        <input id="rdoDeActive" type="radio" name="ActiveCon" value="0" />DeActive  
                         <input id="rdoBoth" type="radio" name="ActiveCon" value="2" />Both 

                    </td>
                  <td style="width: 15%; text-align: right"> &nbsp;
                    </td>
                    <td style="width: 45%; text-align: left">
                        &nbsp;
                    </td>
                </tr>
                
            </table>

        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" />
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
         <div id="ItemOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
             <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display:none"/>
             </div>
    </div>

    <script id="tb_ProcessSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdProcessSearch"
    style="width:950px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>                   
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Process Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Process ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
		</tr>
        <#       
        var dataLength=ItemData.length;  
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ItemData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>                             
                    <td class="GridViewLabItemStyle" id="tdIProcess" style="width:200px;">
                       <input type="text" maxlength="100" style="width:280px" value="<#=objRow.Process#>" id="txtProcess" onkeyup="CheckItem(this);" onkeypress="CheckItem(this);" class="requiredField"/>
                     
                       <span id="spnProcessName" onpaste="return false" style="display:none" ><#=objRow.Process#> </span>
                       <span id="spnTypeCon"  style="display:none" /></td>
                    <td class="GridViewLabItemStyle" id="tdProcessID" style="width:140px;display:none"><#=objRow.ProcessID#></td>                    
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:60px;">
                   <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"
                      onclick="chkActiveCon(this)"    <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #> />Yes                         
                         <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0"
                        onclick="chkActiveCon(this)" <#if(objRow.IsActive=="0"){#> 
                        checked="checked"  <#} #>  />No                                               
                        <span id="spnActive" style="display:none"   ><#=objRow.IsActive#></span>
                         <span id="spnActiveCon" style="display:none"   />
                    </td>
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <script type="text/javascript">
        function CheckItem(rowid) {
            $("#spnErrorMsg").text('');
            var txtProcess = $.trim($(rowid).closest('tr').find('#txtProcess').val());
            var spnProcessName = $.trim($(rowid).closest('tr').find('#spnProcessName').html());                      
            if ((txtProcess != spnProcessName) ) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnTypeCon').html('1'));
            }
            else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnTypeCon').html('0'));
            }
            else {
                $.trim($(rowid).closest('tr').find('#spnTypeCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
            }                        
        }
      
        function chkActiveCon(rowid) {
            $("#spnErrorMsg").text('');
            var rdotdActive = $(rowid).closest('tr').find('#tdActive input[type=radio]:checked').val();
            var spnActive = $.trim($(rowid).closest('tr').find('#spnActive').html());          
            if (rdotdActive != spnActive) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('1'));
            }
            else if (($.trim($(rowid).closest('tr').find('#spnTypeCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
            }
            else {
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
            }
        }
       
        $(function () {
            $("#btnUpdate").bind("click", function () {
                $('#btnUpdate').attr('disabled', 'disabled');
                if (validateProcessUpdate() == true) {
                    var resultItemUpdate = itemUpdate();
                    $.ajax({
                        url: "Services/Process_Master.asmx/UpdateProcess",
                        data: JSON.stringify({ Data: resultItemUpdate }),
                        type: "Post",
                        async: false,
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Updated Successfully');
                            $('#txtProcess').val('');
                                $('#btnUpdate').removeAttr('disabled');
                                $('#ItemOutput').html('');
                                $('#ItemOutput,#btnUpdate').hide();
                                $('#rdoActive').prop('checked', 'checked');
                            }
                            else {
                               $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            }
                        },
                        error: function (xhr, status) {
                                $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        }
                    });
                }
                else {
                    $('#btnUpdate').removeAttr('disabled');
                }
            });
            
        });
        function validateProcessUpdate() {
            var con = 0; var tableCon = 1;
            $("#tb_grdProcessSearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");              
                if (id != "Header") {
                    if (($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                        if ($.trim($rowid.find("#txtProcess").val()) == "") {
                            $("#spnErrorMsg").text('Please Enter Process Name');
                            $rowid.find("#txtProcess").focus();
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
                $("#spnErrorMsg").text('Please Change Process Name OR Active Condition');
                return false;
            }           
            return true;
        }
        function itemUpdate() {
            if ($('#tb_grdProcessSearch tr').length > 0) {
                var con = 0;
               // $('#btnUpdate').prop('disabled', 'disabled');
                var dataItem = new Array();
                var ObjItem = new Object();
                $("#tb_grdProcessSearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");                  
                    if (id != "Header") {
                        if (($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                            ObjItem.Process = encodeURIComponent($.trim($rowid.find("#txtProcess").val()));
                            ObjItem.ProcessID = $.trim($rowid.find("#tdProcessID").text());
                            if ($rowid.find("#rdotdActive").is(':checked'))
                                ObjItem.IsActive = "1";
                            else
                                ObjItem.IsActive = "0";
                           
                            dataItem.push(ObjItem);
                            ObjItem = new Object();
                        }
                    }

                });
                return dataItem;
            }
        }
        function hideAllDetail() {
            $('#ItemOutput').html('');
            $('#ItemOutput,#btnUpdate').hide();
          
            $("#spnErrorMsg").text('');
            $('#txtProcess').val('');
        }

        $(function () {
            if ($("#rdoNew").is(':checked')) {
                $("#btnSave").val('Save');
            }
            if ($("#rdoEdit").is(':checked')) {
                $("#btnSave").val('Search');
            }

            $("#rdoNew").bind("click", function () {
                $("#btnSave").val('Save');
                $('#btnSave').removeAttr('disabled');
                $(".trCondition").hide();
                hideAllDetail();
            });

            $("#rdoEdit").bind("click", function () {
                $("#btnSave").val('Search');
                $('#btnSave').removeAttr('disabled');
                $(".trCondition").show();
                hideAllDetail();
            });

            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnSave').attr('disabled', 'disabled');
                if ($("#btnSave").val() == "Search") {
                    bindProcess();
                }
                else if ($("#btnSave").val() == "Save") {                    
                    saveProcess();
                }
            });
        });

        function Process() {
            var data = new Array();
            var objItem = new Object();
            objItem.Process = encodeURIComponent($.trim($('#txtProcess').val()));
            data.push(objItem);
            return data;
        }

        function validateProcess() {
            
            if ($("#txtProcess").val() == "") {
                $("#spnErrorMsg").text('Please Enter Process Name');
                $("#txtProcess").focus();
                return false;
            }
            return true;
        }

        function bindProcess() {
            $("#spnErrorMsg").text('');
            if ($.trim($("#txtProcess").val()) == "") {
                $("#spnErrorMsg").text('Please Enter Process Name');
                $('#btnSave').removeAttr('disabled');
                $("#txtProcess").focus();
                return;
            }
            var type = "";
            if ($("#rdoActive").is(':checked')) 
                type = "1";
            else if ($("#rdoDeActive").is(':checked')) 
                type = "0";
            else 
                type = "2";
            $.ajax({
      
             url: "Services/Process_Master.asmx/LoadProcesses",
                data: '{Process:"' + $("#txtProcess").val() + '",Type:"' + type + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    if (result != "0") {
                        ItemData = $.parseJSON(result.d);
                        if (ItemData != null) {
                            var output = $('#tb_ProcessSearch').parseTemplate(ItemData);
                            $('#ItemOutput').html(output);
                            $('#ItemOutput,#btnUpdate').show();
                            $('#btnSave').removeAttr('disabled');
                        }
                    }
                    else {
                        $('#ItemOutput').html();
                        $('#ItemOutput,#btnUpdate').hide();
                         $("#spnErrorMsg").text('Record Not Exist');
                            $('#txtProcess').focus();
                        $('#btnSave').removeAttr('disabled');
                    }
                },
                error: function (xhr, status) {
                    $('#ItemOutput').html();
                    $('#ItemOutput').hide();
                }
            });
        }
        
       function saveProcess() {
            if (validateProcess() == true) {
                $.ajax({
                    url: "Services/Process_Master.asmx/SaveProcess",
                    data: '{Process:"' + $("#txtProcess").val() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                success: function (result) {
                        if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Saved Successfully');
                            $('#txtProcess').val('');
                            $("#btnSave").removeAttr('disabled');
                        }
                        else if (result.d == "2") {
                            $("#spnErrorMsg").text('Process Already Exist');
                            $('#txtProcess').focus();
                            $("#btnSave").removeAttr('disabled');
                        }                       
                        else {
                         $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            $('#txtProcess').focus();
                        }
                },
                error: function (xhr, status) {
                    $('#ItemOutput').html();
                    $('#ItemOutput').hide();
                }
            });
            }
            else {
                $('#btnSave').removeAttr('disabled');
            }
        }
        
    </script>
</asp:Content>

