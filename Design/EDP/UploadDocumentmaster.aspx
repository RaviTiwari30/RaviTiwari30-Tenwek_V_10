<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UploadDocumentmaster.aspx.cs" Inherits="Design_EDP_UploadDocumentmaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   <script type="text/javascript" src="../../Scripts/Message.js"></script> 
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" />

    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <b>Upload Document Master</b><br />
                
                    <asp:Label ID="lblmsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
           
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Upload Document Master
            </div>
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                             <input type="radio" id="rdbOPD"  name="Type" title="OPD" checked="checked" onclick="bindDocumentName()" value="0" />OPD &nbsp;
                        <input type="radio" id="rdbIPD" name="Type" title="IPD" value="1" onclick="bindDocumentName()" />IPD
                        </div>
                          <div class="col-md-5">
                            <label class="pull-left">
                                 New&nbsp;Document&nbsp;Master
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtDocumentName" ClientIDMode="Static" runat="server" Width="95%"
                            ToolTip="Enter Document Name" TabIndex="1" MaxLength="50"></asp:TextBox>
                       <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <span id="spnDocumentID" style="display:none"></span> 
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus">
                           <option value="1">Active</option>
                           <option value="0">Deactve</option>
                       </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-9">
                        </div>
                      
                        <div class="col-md-2">
                            <input type="button" value="Update"  style="display:none" class="ItDoseButton" id="btnUpdate" onclick="UpdateDocumentMaster()" />
                        </div>
                          <div class="col-md-2">
                            <input type="button" value="Save" class="ItDoseButton" id="btnSave" onclick="SaveDocumentMaster()" />
                        </div>
                        <div class="col-md-2">
                            <input type="button" value="Cancel"  style="display:none" class="ItDoseButton" id="btnCancel" onclick="CancelDocumentMaster()" />
                        </div>
                        <div class="col-md-9">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style=" text-align: center;">

            <div id="DocumentOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
        </div>


    </div>
     <script id="tb_grdDocSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_DocSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Document Name</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Status</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Edit</th>
		</tr>
        <#       
        var dataLength=DocumentData.length;
      if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {              
            
        var objRow = DocumentData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:40px;display:none" ><#=objRow.ID#></td>                  
                    <td class="GridViewLabItemStyle" id="tdName" style="width:200px;"><#=objRow.NAME#></td>
                        <td class="GridViewLabItemStyle" id="tdstatus" style="width:200px;display:none"><#=objRow.IsActive#></td>
                        <td class="GridViewLabItemStyle" id="td1" style="width:200px;"><#=objRow.STATUS#></td>                                                                                                              
                   <td class="GridViewLabItemStyle">
                       <img src="../../Images/edit.png" style="cursor:pointer" onclick="DocumentMaster(this)"  title="Click To Edit"/>
                   </td>
                    </tr>           
        <#}#>                     
     </table>   
        <table id="tableDocCount" style="border-collapse:collapse;">
       <tr>
<# 
     for(var j=0;j<_PageCount;j++){ #>
     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}         
           
    
#>


     </tr>
     
     </table>   
    </script>
     <script type="text/javascript">
         function SaveDocumentMaster() {
             var Type;
             $("#btnSave").attr('disabled', 'disabled');
             if ($.trim($("#txtDocumentName").val()) != "") {
                 $("#lblmsg").text('');
                 if ($('#rdbOPD').is(':checked'))
                     Type = "OPD";
                 else
                     Type = "IPD";
                 $.ajax({
                     url: "UploadDocumentmaster.aspx/SaveDocumentMaster",
                     data: '{DocumentName:"' + $.trim($("#txtDocumentName").val()) + '", Status:"' + $('#ddlStatus').val() + '", Type:"' + Type + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM01', 'lblmsg');
                         }
                         else if (result.d == "2") {
                             DisplayMsg('MM122', 'lblmsg');
                             $("#btnSave").removeAttr('disabled');
                             return;
                         }
                         else {
                             DisplayMsg('MM05', 'lblmsg');
                         }
                         hideDetail();
                         $("#btnSave").removeAttr('disabled');
                     },
                     error: function (xhr, status) {
                         window.status = status + "\r\n" + xhr.responseText;

                         DisplayMsg('MM05', 'lblmsg');
                     }
                 });
             }

             else {
                 $("#lblmsg").text('Please Enter Document Name');
                 $("#btnSave").removeAttr('disabled');
             }
         }
         var _PageSize = 20;
         var _PageNo = 0;
         var DocSpecializationData = "";
         function bindDocumentName() {
             var Type;
             if ($('#rdbOPD').is(':checked'))
                 Type = "OPD";
             else
                 Type = "IPD";
             $.ajax({
                 url: "UploadDocumentmaster.aspx/bindDocumentName",
                 data: '{Type:"' + Type + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d != "") {
                         DocumentData = jQuery.parseJSON(result.d);
                         if (DocumentData != null) {

                             _PageCount = DocumentData.length / _PageSize;
                             showPage('0');
                         }
                     }
                     else {
                         $('#DocumentOutput').html();
                         $('#DocumentOutput').hide();
                         DisplayMsg('MM04', 'lblmsg');

                     }
                 },
                 error: function (xhr, status) {
                     window.status = status + "\r\n" + xhr.responseText;
                     $('#DocumentOutput').html();
                     $('#DocumentOutput').hide();
                     DisplayMsg('MM05', 'lblmsg');
                 }
             });
         }
         function showPage(_strPage) {
             _StartIndex = (_strPage * _PageSize);
             _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
             var output = $('#tb_grdDocSearch').parseTemplate(DocSpecializationData);
             $('#DocumentOutput').html(output);
             $('#DocumentOutput').show();

         }
         function hideDetail() {
             bindDocumentName();
             $("#btnSave").show();
             $("#btnUpdate,,#btnCancel").hide();
             $("#txtDocumentName").val('');
         }
         $(function () {
             bindDocumentName();
         });

         function DocumentMaster(rowid) {
             $("#lblmsg").text('');
             var ID = $(rowid).closest('tr').find("#tdID").text();
             $("#btnSave").hide();
             $("#btnUpdate,#btnCancel").show();
             $("#txtDocumentName").val($(rowid).closest('tr').find("#tdName").text());
             $("#spnDocumentID").text(ID);
             $("#txtDocumentName").focus();
             $("#ddlStatus").val($(rowid).closest('tr').find("#tdstatus").text());
             //$('#txtDepartment').setCursorToTextEnd();
         }
         (function ($) {
             $.fn.setCursorToTextEnd = function () {
                 $initialVal = this.val();
                 this.val($initialVal + ' ');
                 this.val($initialVal);
             };
         })(jQuery);
         function UpdateDocumentMaster() {
             $("#btnUpdate").attr('disabled', 'disabled');
             if ($.trim($("#txtDocumentName").val()) != "") {
                 $("#lblmsg").text('');
                 var Type;
                 if ($('#rdbOPD').is(':checked'))
                     Type = "OPD";
                 else
                     Type = "IPD";
                 $.ajax({
                     url: "UploadDocumentmaster.aspx/UpdateDocumentMaster",
                     data: '{DocumentName:"' + $.trim($("#txtDocumentName").val()) + '",ID:"' + $("#spnDocumentID").text() + '", Status:"' + $('#ddlStatus').val() + '",Type:"' + Type + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM02', 'lblmsg');
                         }
                         else if (result.d == "2") {
                             DisplayMsg('MM122', 'lblmsg');
                             $("#btnUpdate").removeAttr('disabled');
                             return;
                         }
                         else {
                             DisplayMsg('MM05', 'lblmsg');
                         }
                         hideDetail();
                         $("#btnUpdate").removeAttr('disabled');
                     },
                     error: function (xhr, status) {
                         window.status = status + "\r\n" + xhr.responseText;

                         DisplayMsg('MM05', 'lblmsg');
                     }
                 });
             }

             else {
                 $("#lblmsg").text('Please Enter Document Name');
                 $("#btnUpdate").removeAttr('disabled');
             }
         }

         function CancelDocumentMaster() {
             $("#btnSave").show();
             $("#btnUpdate,#btnCancel").hide();
             $("#txtDocumentName").val('');
             $('#ddlStatus').val(1);
             $("#lblmsg").text('');
         }
         </script>
</asp:Content>

