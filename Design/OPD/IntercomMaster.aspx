<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IntercomMaster.aspx.cs" Inherits="Design_OPD_IntercomMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" />

    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Intercom Master</b><br />
                    <asp:Label ID="lblmsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Intercom Master
            </div>
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                New&nbsp;Intercom
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" ClientIDMode="Static" runat="server" Width="95%" 
                            ToolTip="Enter Name" TabIndex="1" MaxLength="50"></asp:TextBox>
                            <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <span id="spnID" style="display:none"></span>  
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtNumber" tabindex="2" onkeypress="return CheckDigit(this,event)" />
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="rdoActive" name="Label"  type="radio" value="Active" checked="checked" />Active
                            <input id="rdoDeActive" name="Label"  type="radio" value="DeActive" />DeActive
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-9">
                          
                        </div>
                        <div class="col-md-2">
                          
                        </div>
                         <div class="col-md-2">
                          
                        </div>
                         <div class="col-md-2">
                          
                        </div>
                        <div class="col-md-9">
                          
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table border="0" style="width: 100%">
                <tr>
            <td style="width: 15%">
             </td>
             <td style="width: 26%">
             </td>
             <td style="width: 20%;text-align:left" >
                <input type="button" value="Update"  style="display:none" class="ItDoseButton" id="btnUpdate" onclick="update()" tabindex="3" />
                  <input type="button" value="Save" class="ItDoseButton" id="btnSave" onclick="save()" tabindex="3" />
                &nbsp;<input type="button" value="Cancel"  style="display:none" class="ItDoseButton" id="btnCancel" onclick="cancel()" tabindex="4" />
                  </td>
             <td style="width: 25%">
             </td>
             <td style="width: 25%">
             </td>
         </tr>
            </table>
        </div>

        <div class="POuter_Box_Inventory" style=" text-align: center;">

            <div id="divOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
        </div>


    </div>
     <script id="tb_grdSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_Search"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Name</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Number</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Edit</th>
		</tr>
        <#       
        var dataLength=IntercomData.length;
      if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {              
            
        var objRow = IntercomData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:40px;display:none" ><#=objRow.ID#></td>                  
                        
                    <td class="GridViewLabItemStyle" id="tdName" style="width:200px;"><#=objRow.Name#></td>   
                        <td class="GridViewLabItemStyle" id="tdNumber" style="width:200px;"><#=objRow.Number#></td>                                                                                                              
                        <td class="GridViewLabItemStyle" id="tdStatus"  style="width:40px;" ><#=objRow.IsActive#></td>
                   <td class="GridViewLabItemStyle">
                       <img src="../../Images/edit.png" style="cursor:pointer" onclick="Intercom(this)"  title="Click To Edit" alt=""/>
                   </td>
                    </tr>           
        <#}#>                     
     </table>   
        <table id="tableCount" style="border-collapse:collapse;">
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
         function CheckDigit(element, evt) {
             $("#lblMsg").text('');
             var charCode = (evt.which) ? evt.which : event.keyCode
             if ((charCode < 48 || charCode > 57) && (charCode != 8) && (charCode != 44)) {
                 $("#lblMsg").text('Enter Numeric Value Only And Comma');
                 return false;
             }
             else {
                 $("#lblMsg").text(' ');
                 return true;
             }
         }
         function save() {
             $("#btnSave").attr('disabled', 'disabled');
             if ($.trim($("#txtName").val()) != "" && $.trim($("#txtNumber").val()) != "") {
                 var Status = 0;
                 if ($("#rdoActive").is(':checked'))
                     Status = 1;
                 $("#lblmsg").text('');
                 $.ajax({
                     url: "IntercomMaster.aspx/save",
                     data: '{Name:"' + $.trim($("#txtName").val()) + '",Number:"' + $.trim($("#txtNumber").val()) + '",Status:"' + Status + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM01', 'lblmsg');
                         }
                         else if (result.d == "2") {
                             $('#lblmsg').text('Altready Exists');
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
                 $("#lblmsg").text('Please Enter Name Or Number');
                 $("#btnSave").removeAttr('disabled');
             }
         }
         var _PageSize = 10;
         var _PageNo = 0;
         var IntercomData = "";
         function bindIntercom() {
             $.ajax({
                 url: "IntercomMaster.aspx/bindIntercom",
                 data: '{}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d != "") {
                         IntercomData = jQuery.parseJSON(result.d);
                         if (IntercomData != null) {

                             _PageCount = IntercomData.length / _PageSize;
                             showPage('0');
                         }
                     }
                     else {
                         $('#divOutput').html();
                         $('#divOutput').hide();
                         DisplayMsg('MM04', 'lblmsg');

                     }
                 },
                 error: function (xhr, status) {
                     window.status = status + "\r\n" + xhr.responseText;
                     $('#divOutput').html();
                     $('#divOutput').hide();
                     DisplayMsg('MM05', 'lblmsg');
                 }
             });
         }
         function showPage(_strPage) {
             _StartIndex = (_strPage * _PageSize);
             _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
             var output = $('#tb_grdSearch').parseTemplate(IntercomData);
             $('#divOutput').html(output);
             $('#divOutput').show();

         }
         function hideDetail() {
             bindIntercom();
             $("#btnSave").show();
             $("#btnUpdate,,#btnCancel").hide();
             $("#txtName,#txtNumber").val('');
             $("#rdoActive").prop('checked', true);
         }
         $(function () {
             bindIntercom();
         });

         function Intercom(rowid) {
             $("#lblmsg").text('');
             var ID = $(rowid).closest('tr').find("#tdID").text();
             $("#btnSave").hide();
             $("#btnUpdate,#btnCancel").show();
             $("#txtName").val($(rowid).closest('tr').find("#tdName").text());
             $("#txtNumber").val($(rowid).closest('tr').find("#tdNumber").text());
             var Status = $(rowid).closest('tr').find("#tdStatus").text();
             if (Status == 'Yes')
                 $("#rdoActive").prop('checked', true);
             else
                 $("#rdoDeActive").prop('checked', true);
             $("#spnID").text(ID);
             $("#txtName").focus();
         }
         (function ($) {
             $.fn.setCursorToTextEnd = function () {
                 $initialVal = this.val();
                 this.val($initialVal + ' ');
                 this.val($initialVal);
             };
         })(jQuery);
         function update() {
             $("#btnUpdate").attr('disabled', 'disabled');
             if ($.trim($("#txtName").val()) != "" && $.trim($("#txtNumber").val()) != "") {
                 $("#lblmsg").text('');
                 var Status = 0;
                 if ($("#rdoActive").is(':checked'))
                     Status = 1;
                 $.ajax({
                     url: "IntercomMaster.aspx/Update",
                     data: '{Name:"' + $.trim($("#txtName").val()) + '",Number:"' + $.trim($("#txtNumber").val()) + '",ID:"' + $("#spnID").text() + '",Status:"' + Status + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM02', 'lblmsg');
                         }
                         else if (result.d == "2") {
                             DisplayMsg('MM173', 'lblmsg');
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
                 $("#lblmsg").text('Please Enter Name');
                 $("#btnUpdate").removeAttr('disabled');
             }
         }

         function cancel() {
             $("#btnSave").show();
             $("#btnUpdate,#btnCancel").hide();
             $("#txtName,#txtNumber").val('');
             $("#lblmsg").text('');
         }
         </script>
</asp:Content>

