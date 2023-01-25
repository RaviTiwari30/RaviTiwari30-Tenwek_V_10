<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TPAProcessMaster.aspx.cs" Inherits="Design_Recovery_TPAProcessMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <script type="text/javascript">
        $(function () {
            getPanel("ALL");
            getProcess();
            getValidityData();
        });
        $(document).ready(function () {
             $(".trprocess").show();
        });
        function getPanel(PanelGroup) {
            $("#ddlPanel option").remove();
            $.ajax({
                url: "../common/CommonService.asmx/getPanel",
                data: '{PanelGroup:"' + PanelGroup + '" }',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $("#ddlPanel").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < PanelData.length; i++) {
                            $("#ddlPanel").append($("<option></option>").val(PanelData[i].PanelID).html(PanelData[i].Company_Name));
                        }
                    }
                },
                error: function (xhr, status) {
                    $("#ddlPanel").attr("disabled", false);
                }
            });
        }
         function getProcess() {
            $("#ddlProcess option").remove();
            $.ajax({
                url: "Services/Panel_Process_Master.asmx/getProcess",
                data: '{ }',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    ProcessData = $.parseJSON(result.d);
                    if (ProcessData.length == 0) {
                        $("#ddlProcess").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        $("#ddlProcess").append($("<option></option>").val("0").html("---Select---"));
                        for (i = 0; i < ProcessData.length; i++) {
                            $("#ddlProcess").append($("<option></option>").val(ProcessData[i].ProcessID).html(ProcessData[i].Name));
                        }
                    }
                },
                error: function (xhr, status) {
                    $("#ddlProcess").attr("disabled", false);
                }
            });
        }
       
         function getValidityData() {
             $("#ddlValidity option").remove();
             $.ajax({
                 url: "Services/Panel_Process_Master.asmx/getValidity",
                 data: '{ }',
                 type: "POST",
                 async: false,
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 success: function (result) {
                     ValidityData = $.parseJSON(result.d);
                     if (ValidityData.length == 0) {
                         $("#ddlValidity").append($("<option></option>").val("0").html("---No Data Found---"));
                     }
                     else {
                         $("#ddlValidity").append($("<option></option>").val("0").html("---Select---"));
                         for (i = 0; i < ValidityData.length; i++) {
                             $("#ddlValidity").append($("<option></option>").val(ValidityData[i].Validity).html(ValidityData[i].Validity));
                         }
                     }
                 },
                 error: function (xhr, status) {
                     $("#ddlValidity").attr("disabled", false);
                 }
             });
         }
        
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>TPA Recovery Process Mapping Master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
                <input id="rdoNew" type="radio" name="Con" value="New" checked="checked" />New
           <input id="rdoEdit" type="radio" name="Con" value="Edit" />Edit    
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 15%; text-align: right">Panel :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <select id="ddlPanel" tabindex="1" style="width: 256px" title="Select Panel"></select>

                    </td>
                    <td style="width: 15%; text-align: right">&nbsp;
                        
                    </td>
                    <td style="width: 45%; text-align: left">
                      
                    </td>
                </tr>
             
                <tr  class="trprocess" style="display:none">
                    <td style="width: 15%; text-align: right">Process :&nbsp;
                        
                    </td>
                    <td style="width: 30%; text-align: left">
                          
                    <select id="ddlProcess" tabindex="2" style="width: 256px" title="Select Process"  class="requiredField"></select>                    
                    </td>
                    <td style="width: 15%; text-align: right"> Validity in Days :&nbsp;
                    </td>
                    <td style="width: 45%; text-align: left">
                    <asp:DropDownList runat="server" ID="ddlValidity"  style="width: 256px" ClientIDMode="Static"  class="requiredField">                   
                    </asp:DropDownList>
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

    <script id="tb_ItemSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdProcessListSearch"
    style="width:950px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Panel</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;;display:none;">Panel ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Process</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">Process ID</th>      
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Validity</th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Priority</th>          
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">Checked</th>
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
                    <td class="GridViewLabItemStyle" id="tdPanel" style="width:140px; text-align:left"><#=objRow.Panel#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelID"  style="width:80px;display:none;" ><#=objRow.PanelID#></td>
                    <td class="GridViewLabItemStyle" id="tdProcess" style="width:140px;text-align:left"><#=objRow.Process#></td>
                    <td class="GridViewLabItemStyle" id="tdProcessID" style="width:80px; display:none;"><#=objRow.ProcessID#></td>    
   
                      <td class="GridViewLabItemStyle" id="tdValidity" style="width:70px;">
                       <input type="text" maxlength="100" style="width:90px" value="<#=objRow.Validity#>" id="txtValidity" onkeyup="CheckValidity(this);" onkeypress="CheckValidity(this);"  class="requiredField" />
                       <span id="spnValidity" onpaste="return false" style="display:none" ><#=objRow.Validity#> </span>
                       </td>
                       
                        <td class="GridViewLabItemStyle" id="tdPriority" style="width:70px;">
                       <input type="text" maxlength="100" style="width:90px" value="<#=objRow.Priority#>" id="txtPriority" onkeyup="CheckPriority(this);" onkeypress="CheckPriority(this);"  class="requiredField" />
                       <span id="spnPriority" onpaste="return false" style="display:none" ><#=objRow.Priority#> </span>
                       </td>
                     
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:80px;">
                   <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"
                      onclick="chkActiveCon(this)"    <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #> />Yes                         
                         <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0"
                        onclick="chkActiveCon(this)" <#if(objRow.IsActive=="0"){#> 
                        checked="checked"  <#} #>  />No                                               
                        <span id="spnActive" style="display:none"   ><#=objRow.IsActive#></span>
                         <span id="spnActiveCon" style="display:none"   />
                    </td>
                    <td class="GridViewLabItemStyle" id="tdchkActive"  style="width:80px;display:none;">
                   <input type="checkbox" id="tdchkActive" name="tdchkActive_<#=j+1#>" value="1"
                        <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #> />                         
                        
                    </td>
                    </tr> 
                                                        
                              
        <#}#>                     
     </table>    
    </script>
    <script type="text/javascript">        
      function CheckPriority(rowid) {
            $("#spnErrorMsg").text('');
            var Priority = $.trim($(rowid).closest('tr').find('#txtPriority').val());
            var spnPriority = $.trim($(rowid).closest('tr').find('#spnPriority').html());                      
            if ((Priority != spnPriority) ) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
            }
            else {
                $(rowid).closest('tr').css("background-color", "transparent");
            }                        
        }
      
      
      function CheckValidity(rowid) {
            $("#spnErrorMsg").text('');
            var Validity = $.trim($(rowid).closest('tr').find('#txtValidity').val());
            var spnValidity = $.trim($(rowid).closest('tr').find('#spnValidity').html());                      
            if ((Validity != spnValidity) ) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
            }  
            else {
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
            else {
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
            }
        }
       
        $(function () {
            $("#btnUpdate").bind("click", function () {
                $('#btnUpdate').attr('disabled', 'disabled');
//                if (validateItemUpdate() == true) {
                    var resultPanelProcessListUpdate = PanelProcessListUpdate();
                    $.ajax({
                        url: "Services/Panel_Process_Master.asmx/UpdatePanelProcessList",
                        data: JSON.stringify({ Data: resultPanelProcessListUpdate }),
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                               $("#spnErrorMsg").text('Record Updated Successfully');
                                $('#btnUpdate').removeAttr('disabled');
                                $('#ItemOutput').html('');
                                $('#ItemOutput,#btnUpdate').hide();
                                $('#rdoActive').prop('checked', 'checked');
                                getPanel("ALL");
                            }
                            else {
                                $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            }
                        },
                        error: function (xhr, status) {
                             $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        }
                    });
//                }
//                else {
//                    $('#btnUpdate').removeAttr('disabled');
//                }
            });
            
        });
        
     
        
        function validateItemUpdate() {
            var con = 0; var tableCon = 1;
            $("#tb_grdProcessListSearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");              
                if (id != "Header") {
                    if (($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                        if ($rowid.find("#rdotdActive").is(':checked'))  {
                            $("#spnErrorMsg").text('Please Check  Active Condition');
                            $rowid.find("#rdotdActive").focus();
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
                $("#spnErrorMsg").text('Please Change Active Condition');
                return false;
            }           
            return true;
        }
        function PanelProcessListUpdate() {
            if ($('#tb_grdProcessListSearch tr').length > 0) {
                var con = 0;
                var dataItem = new Array();
                var ObjItem = new Object();
                $("#tb_grdProcessListSearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");           
                    if (id != "Header") {
                           ObjItem.ProcessID = $.trim($rowid.find("#tdProcessID").text());
                            ObjItem.PanelID = $.trim($rowid.find("#tdPanelID").text());
                            ObjItem.Validity = $.trim($rowid.find("#txtValidity").val());
                            ObjItem.Priority = $.trim($rowid.find("#txtPriority").val());
                            if ($rowid.find("#rdotdActive").is(':checked'))
                                ObjItem.IsActive = "1";
                            else
                                ObjItem.IsActive = "0";
                           
                            dataItem.push(ObjItem);
                            ObjItem = new Object();
                    }

                });
                return dataItem;
            }   
            
        }
        function hideAllDetail() {
            $('#ItemOutput').html('');
            $('#ItemOutput,#btnUpdate').hide();
            getPanel("ALL");
            getProcess();
            $("#spnErrorMsg").text('');
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
                $(".trprocess").show();             
                hideAllDetail();
            });
            $("#rdoEdit").bind("click", function () {
                $("#btnSave").val('Search');
                $(".trprocess").hide();
                hideAllDetail();
            });
            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnSave').attr('disabled', 'disabled');
                if ($("#btnSave").val() == "Search") {
                    bindPanelProcessList();
                }
                else if ($("#btnSave").val() == "Save") {                    
                    SavePanelProcess();
                }
            });
        });
        function SavePanelProcess() {
            if (validateItem() == true) {
                var resultItem = Item();
                $.ajax({
                    url: "Services/Panel_Process_Master.asmx/SavePanelProcess",
                     data: '{PanelID:"' + $("#ddlPanel").val() + '",ProcessID:"' + $("#ddlProcess").val() + '",Validity:"' +  $('#<%=ddlValidity.ClientID%>').val() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                success: function (result) {
                        if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Saved Successfully');   
                            $("#btnSave").removeAttr('disabled');
                               getPanel("ALL");
                               getProcess();
                               $('#<%=ddlValidity.ClientID%>').val('Select Validity')
                        }
                        else if (result.d == "2") {
                            $("#spnErrorMsg").text('Process Already Mapped with Panel');
                            $("#btnSave").removeAttr('disabled');
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
                $('#btnSave').removeAttr('disabled');
            }
        }
        function Item() {
            var data = new Array();
            var objItem = new Object();
            objItem.ProcessID = $('#ddlProcess').val();
            objItem.PanelID = $('#ddlPanel').val();
            objItem.Validity = $('#ddlValidity').val();
            data.push(objItem);
            return data;
        }
        function validateItem() {
         var Validity =  $('#<%=ddlValidity.ClientID%>').val();
         var ProcessID=$("#ddlProcess").val();
         var PanelID=$("#ddlPanel").val()
            if (PanelID == "0") {
                $("#spnErrorMsg").text('Please Select Panel');
                $("#ddlPanel").focus();
                return false;
            }
            if (ProcessID == "0") {
                $("#spnErrorMsg").text('Please Select Process');
                $("#ddlProcess").focus();
                return false;
            }
              if (Validity == "0") {
                $("#spnErrorMsg").text('Please Select Validity');
                $("#ddlValidity").focus();
                return false;
              }

            return true;
        }
        function bindPanelProcessList() {
            $("#spnErrorMsg").text('');            
            $.ajax({
                url: "services/Panel_Process_Master.asmx/LoadPanelProcessList",
                data: '{PanelID:"' + $("#ddlPanel").val() + '"}',
                 type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                   if (result != "0") {
                        ItemData = $.parseJSON(result.d);                     
                        if (ItemData != null) {
                            var output = $('#tb_ItemSearch').parseTemplate(ItemData);
                            $('#ItemOutput').html(output);
                            $('#ItemOutput,#btnUpdate').show();
                            $('#btnSave').removeAttr('disabled');
                        }
                    }
                    else {
                        $('#ItemOutput').html();
                        $('#ItemOutput,#btnUpdate').hide();
                        $("#spnErrorMsg").text('Record Not Exist');
                        $('#btnSave').removeAttr('disabled');
                    }
                },
                error: function (xhr, status) {
                    $('#ItemOutput').html();
                    $('#ItemOutput').hide();
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            });
        }
    </script>
</asp:Content>

