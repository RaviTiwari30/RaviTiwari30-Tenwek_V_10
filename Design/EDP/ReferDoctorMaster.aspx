<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ReferDoctorMaster.aspx.cs" Inherits="Design_EDP_ReferDoctorMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">   
    
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Refer Doctor Master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
                <input id="rdoNew" type="radio" name="Con" value="New" checked="checked" />New
                <input id="rdoEdit" type="radio" name="Con" value="Edit" />Edit    
            </div>
        </div>


        <div class="POuter_Box_Inventory">
          
            <%--Save Refer Doctor--%>
            	<div id="Save-body">
                       <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <select id="ddlTitleRefDoc" style="border-bottom-color:red;border-bottom-width:2px"  title="Select Title">
							<option value="Dr."  >Dr.</option>
							<option value="Prof.Dr."  >Prof Dr.</option>
							  </select>
                        </div>
                            <div class="col-md-4">
                              <input type="text" autocomplete="off" style="border-bottom-color:red;border-bottom-width:2px" onlyText="50" maxlength="50" allowCharsCode="40,41"   id="txtRefDoc" style="text-transform:uppercase"   maxlength="50"  title="Enter Refer Doctor Name" />
                            </div>
                         
                            <div class="col-md-3">
                            <label class="pull-left">
                                Contact No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" autocomplete="off"  id="txtRefDocPhoneNo" onkeyup="previewCountDigit(event,function(e){});" allow   maxlength="10" onlynumber="10"  style="width:196px" data-title="Enter Refer Doctor Contact No" />    
                        </div>

                            <div class="col-md-3">
                            <label class="pull-left">
                              Address
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                         <div class="col-md-5">
                              <textarea id="txtRefDocAddress"   maxlength="100" title="Enter Refer Doctor Address"></textarea>
                         </div>
                    </div>
				</div>

              <%--End Refer Doctor Save--%>

           <%--Update Refer Doctor--%>

            <div id="Update-body">
					
                 <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <select id="ddlTitleRefDocSearch" style="border-bottom-color:red;border-bottom-width:2px"  title="Select Title">
							<option value="Dr."  >Dr.</option>
							<option value="Prof.Dr."  >Prof Dr.</option>
							  </select>
                        </div>
                            <div class="col-md-4">
                              <input type="text" autocomplete="off" style="border-bottom-color:red;border-bottom-width:2px" onlyText="50" maxlength="50" allowCharsCode="40,41"   id="txtRefDocNameSearch" style="text-transform:uppercase"   maxlength="50"  title="Enter Refer Doctor Name" />
                            </div>
                         
                        <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5"></div>
                        <div class="col-md-3">
                        <label class="pull-left">                             
                        </label>
                        <b class="pull-right"></b>
                        </div>
                         <div class="col-md-5"></div>

                    </div>

                 <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                
                            </label>
                            <b class="pull-right"></b>
                        </div>
                       
                            <div class="col-md-6">
                              <input id="rdoActive" type="radio" name="ActiveCon" value="1" checked="checked" />Active
                        <input id="rdoDeActive" type="radio" name="ActiveCon" value="0" />DeActive  
                         <input id="rdoBoth" type="radio" name="ActiveCon" value="2" />Both 
                            </div>
                         
                        <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5"></div>
                        <div class="col-md-3">
                        <label class="pull-left">                             
                        </label>
                        <b class="pull-right"></b>
                        </div>
                         <div class="col-md-5"></div>

                    </div>         
				</div>

<%--            End Refer Doctor Update--%>

        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" />
     <%--   </div>
         <div class="POuter_Box_Inventory" style="text-align: center">--%>
         <div id="ItemOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
             <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display:none"/>
             </div>
    </div>

    <script id="tb_RefDocSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdRefDocSearch"
    style="width:auto;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>                   
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Doctor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Doctor ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Mobile</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Active</th>
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
                    <td class="GridViewLabItemStyle" id="tdRefDocName" style="width:200px;">
                       <input type="text" maxlength="100" style="width:280px" value="<#=objRow.Name#>" id="txtRefDocName" onkeyup="CheckItem(this);" onkeypress="CheckItem(this);" class="requiredField"/>
                     
                       <span id="spnRefDocName" onpaste="return false" style="display:none" ><#=objRow.Name#> </span>
                       <span id="spnTypeCon"  style="display:none" /></td>
                    <td class="GridViewLabItemStyle" id="tdDoctorID" style="width:140px;display:none"><#=objRow.DoctorID#></td>    
                        
                          <td class="GridViewLabItemStyle" id="tdMobile" style="width:100px;">
                       <input type="text" autocomplete="off" maxlength="10" onlynumber="10" style="width:100px" value="<#=objRow.Mobile#>" id="txtMobile" onkeyup="CheckMobile(this);previewCountDigit(event,function(e){});" onkeypress="CheckMobile(this);" class="requiredField ItDoseTextinputNum" />                      
                       <span id="SpnMobile" onpaste="return false" style="display:none" ><#=objRow.Mobile#> </span>
                       </td>
                         
                        <td class="GridViewLabItemStyle" id="tdAddress" style="width:200px;">
                       <input type="text" maxlength="100" style="width:280px" value="<#=objRow.House_No#>" id="txtAddress" onkeyup="CheckAddress(this);" onkeypress="CheckAddress(this);"  class="requiredField"/>                     
                       <span id="SpnAddress" onpaste="return false" style="display:none" ><#=objRow.House_No#> </span>
                       </td>
                                       
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:100px;">
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
            var txtRefDocName = $.trim($(rowid).closest('tr').find('#txtRefDocName').val());
            var spnRefDocName = $.trim($(rowid).closest('tr').find('#spnRefDocName').html());
            if ((txtRefDocName != spnRefDocName)) {
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


        function CheckMobile(rowid) {
            $("#spnErrorMsg").text('');

          

            var txtMobile = $.trim($(rowid).closest('tr').find('#txtMobile').val());
            var spnMobile = $.trim($(rowid).closest('tr').find('#spnMobile').html());
            if ((txtMobile != spnMobile)) {
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
      
        function CheckAddress(rowid) {
            $("#spnErrorMsg").text('');
            var txtAddress = $.trim($(rowid).closest('tr').find('#txtAddress').val());
            var spnAddress = $.trim($(rowid).closest('tr').find('#spnAddress').html());
            if ((txtAddress != spnAddress)) {
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
                if (validateRefDocUpdate() == true) {
                    var resultItemUpdate = itemUpdate();
                    $.ajax({
                        url: "ReferDoctorMaster.aspx/UpdateRefDoc",
                        data: JSON.stringify({ Data: resultItemUpdate }),
                        type: "Post",
                        async: false,
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Updated Successfully');
                            $('#txtRefDocNameSearch').val('');
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
        function validateRefDocUpdate() {
            var con = 0; var tableCon = 1;
            $("#tb_grdRefDocSearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");              
                if (id != "Header") {
                    if (($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                        if ($.trim($rowid.find("#txtRefDocName").val()) == "") {
                            $("#spnErrorMsg").text('Please Enter Doctor Name');
                            $rowid.find("#txtRefDocName").focus();
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
                $("#spnErrorMsg").text('Please Change Doctor Name OR Active Condition');
                return false;
            }           
            return true;
        }
        function itemUpdate() {
            if ($('#tb_grdRefDocSearch tr').length > 0) {
                var con = 0;
               // $('#btnUpdate').prop('disabled', 'disabled');
                var dataItem = new Array();
                var ObjItem = new Object();
                $("#tb_grdRefDocSearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");                  
                    if (id != "Header") {
                        if (($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                            ObjItem.Name = encodeURIComponent($.trim($rowid.find("#txtRefDocName").val()));
                            ObjItem.Mobile = encodeURIComponent($.trim($rowid.find("#txtMobile").val()));
                            ObjItem.House_No = encodeURIComponent($.trim($rowid.find("#txtAddress").val()));
                            ObjItem.DoctorID = $.trim($rowid.find("#tdDoctorID").text());
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
            //$('#ItemOutput,#btnUpdate,#Update-body').hide();          
            $("#spnErrorMsg").text('');
        }

        $(function () {
            if ($("#rdoNew").is(':checked')) {
                $("#btnSave").val('Save');
                $('#Save-body').show();
                $('#Update-body,#ItemOutput').hide();
            }
            if ($("#rdoEdit").is(':checked')) {
                $("#btnSave").val('Search');
                $('#Update-body,#ItemOutput').show();
                $('#Save-body').hide();
            }

            $("#rdoNew").bind("click", function () {
                $("#spnErrorMsg").text('');
                $("#btnSave").val('Save');
                $('#btnSave').removeAttr('disabled');
                $('#Save-body').show();
                $('#Update-body,#ItemOutput,#btnUpdate').hide();
            });

            $("#rdoEdit").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#tb_grdRefDocSearch tr').remove();
                $("#btnSave").val('Search');
                $('#btnSave').removeAttr('disabled');
                $('#Update-body,#ItemOutput').show();
                $('#Save-body').hide();
            });

            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnSave').attr('disabled', 'disabled');
                if ($("#btnSave").val() == "Search") {
                    bindRefDoc();
                }
                else if ($("#btnSave").val() == "Save") {                    
                    saveRefDoc();
                }
            });
        });

        function RefDoc() {
            var data = new Array();
            var objItem = new Object();
            objItem.RefDocName = encodeURIComponent($.trim($('#txtRefDocName').val()));
            data.push(objItem);
            return data;
        }

        function validatesave() {
            
            if ($("#txtRefDoc").val() == "") {
                $("#spnErrorMsg").text('Please Enter Doctor Name');
                $("#txtRefDoc").focus();
                return false;
            }
            return true;
        }

        function bindRefDoc() {
            $("#spnErrorMsg").text('');
            //if ($.trim($("#txtRefDocNameSearch").val()) == "") {
            //    $("#spnErrorMsg").text('Please Enter Doctor Name');
            //    $('#btnSave').removeAttr('disabled');
            //    $("#txtRefDocNameSearch").focus();
            //    return;
            //}
            var type = "";
            if ($("#rdoActive").is(':checked')) 
                type = "1";
            else if ($("#rdoDeActive").is(':checked')) 
                type = "0";
            else 
                type = "2";
            $.ajax({
      
                url: "ReferDoctorMaster.aspx/LoadRefDoc",
             data: '{Title:"' + $("#ddlTitleRefDocSearch option:selected").text() + '",RefDocName:"' + $("#txtRefDocNameSearch").val() + '",Type:"' + type + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                        ItemData = $.parseJSON(result.d);
                        if (ItemData != "0") {
                            var output = $('#tb_RefDocSearch').parseTemplate(ItemData);
                            $('#ItemOutput').html(output);
                            $('#ItemOutput,#btnUpdate').show();
                            $('#btnSave').removeAttr('disabled');
                            $commonJsInit(function () { });
                        }
                        else {
                            $('#ItemOutput').html();
                            $('#ItemOutput,#btnUpdate').hide();
                            $("#spnErrorMsg").text('Record Not Exist');
                            $('#txtRefDocNameSearch').focus();
                            $('#btnSave').removeAttr('disabled');
                        }
                },
                error: function (xhr, status) {
                    $('#ItemOutput').html();
                    $('#ItemOutput').hide();
                }
            });
        }
        
        function saveRefDoc() {
            if (validatesave() == true) {
                $.ajax({
                    url: "ReferDoctorMaster.aspx/SaveRefDoc",
                    data: '{Title:"' + $("#ddlTitleRefDoc option:selected").text() + '",DocName:"' + $("#txtRefDoc").val() + '",Mobile:"' + $("#txtRefDocPhoneNo").val() + '",Address:"' + $("#txtRefDocAddress").val() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Saved Successfully');
                            $('#txtRefDoc,#txtRefDocPhoneNo,#txtRefDocAddress').val('');
                            $("#btnSave").removeAttr('disabled');
                        }
                        else if (result.d == "2") {
                            $("#spnErrorMsg").text('Doctor Name Already Exist');
                            $('#txtRefDoc').focus();
                            $("#btnSave").removeAttr('disabled');
                        }                       
                        else {
                         $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                         $('#txtRefDoc').focus();
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

