<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="FileSendStatusReport.aspx.cs" Inherits="Design_MRD_FileSendStatusReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
   
    <script type="text/javascript" >
        $(document).ready(function () {
            
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        });
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();

            });

        });

        

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
      
</script>
     <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>File Send To MRD Status Report</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
         <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
                 Search Criteria
             </div>
             <div class="row">
                 <div class="col-md-1"></div>
                 <div class="col-md-22">
                     <div class="row">
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Patient Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlPatientType" runat="server" ClientIDMode="Static"></asp:DropDownList>
                         </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 UHID
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:TextBox ID="txtPatientID" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" ToolTip="Enter UHID No." TabIndex="1"></asp:TextBox>
                         </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Patient Name
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static" TabIndex="2"
                                 ToolTip="Enter Patient Name"></asp:TextBox>
                         </div>


                     </div>
                     <div class="row">
                         <div class="col-md-3">
                             <label class="pull-left">
                                 IPD No.
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:TextBox ID="txtTransactionNo" runat="server" ClientIDMode="Static" MaxLength="11" ToolTip="Enter IPD No." TabIndex="8"></asp:TextBox>
                             <cc1:FilteredTextBoxExtender ID="ftbTran" runat="server" FilterType="Numbers,Custom" TargetControlID="txtTransactionNo" ValidChars="/">
                             </cc1:FilteredTextBoxExtender>
                         </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Doctor
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="cmbDoctor" runat="server" TabIndex="9" ToolTip="Select Doctor" ClientIDMode="Static" CssClass="cmbDoctor  chosen-select chosen-container">
                             </asp:DropDownList>

                         </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Panel
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="cmbCompany" runat="server" TabIndex="10" ToolTip="Select Panel" ClientIDMode="Static" CssClass="cmbCompany  chosen-select chosen-container">
                             </asp:DropDownList>
                         </div>
                     </div>
                     <div class="row">


                         <div class="col-md-3">
                             <label class="pull-left">
                                 <asp:CheckBox ID="chkIgnore" ClientIDMode="Static" runat="server" Text="Ignore" />
                                 F Date
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">

                             <asp:TextBox ID="ucFromDate" runat="server" TabIndex="14" ClientIDMode="Static" ToolTip="Sent File From Date">
                             </asp:TextBox>
                             <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                 Animated="true" runat="server">
                             </cc1:CalendarExtender>
                         </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 To Date
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:TextBox ID="ucToDate" runat="server" TabIndex="15" ClientIDMode="Static" ToolTip="Sent File To Date"></asp:TextBox>
                             <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                 Animated="true" runat="server">
                             </cc1:CalendarExtender>
                         </div>
                         <div class="col-md-3">
                             <label class="pull-left">File Status</label>
                             <b class="pull-right">:</b>

                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlStatus" runat="server"  TabIndex="12" ToolTip="Select File Status" ClientIDMode="Static">
                                <asp:ListItem Selected="true" Value="2">ALL</asp:ListItem>
                                <asp:ListItem Value="0">Not Received</asp:ListItem>
                                <asp:ListItem Value="1">Received</asp:ListItem>
                            </asp:DropDownList>
                         </div>
                       
                     </div>

                     <div class="row">
                           <div class="col-md-3" style="display: none">
                             <label class="pull-left">
                                 Parent Panel
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5" style="display: none" s>
                             <asp:DropDownList ID="ddlParentPanel" runat="server" TabIndex="11" ClientIDMode="Static"
                                 ToolTip="Select Parent Panel">
                             </asp:DropDownList>
                         </div>

                     </div>
                     <div class="row" style="display: none">
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Room Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="cmbRoom" ClientIDMode="Static" runat="server" TabIndex="7" ToolTip="Select Room Type">
                             </asp:DropDownList>
                         </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Discharge Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlDischageType" ClientIDMode="Static" runat="server" TabIndex="13"
                                 ToolTip="Select Discharge Type">
                             </asp:DropDownList>
                         </div>


                     </div>


                 </div>
                 <div class="col-md-1"></div>
             </div>
         </div>
         <div class="POuter_Box_Inventory">
                 <div class="row">
                     <div style="text-align: center;" class="col-md-24">
                     <input type="button" id="btnSearch"  value="Search" class="ItDoseButton" onclick="SearchData()"/> 
                        
                         </div>                        
              </div>
             </div>
              <div class="POuter_Box_Inventory">
                 <div class="row">
                     <div  class="col-md-24">
                          <label style="width:25px;height:25px;margin-left:5px;float:left;background-color:green;" class="circle"></label>
                            <b style="margin-top:5px;margin-left:5px;float:left">Received</b>
                            
                            <label  style="width:25px;height:25px;margin-left:5px;float:left;background-color:yellow;" class="circle"></label>
                            <b style="margin-top:5px;margin-left:5px;float:left">Pending</b>
                         </div>                        
              </div>
             </div>
            <div class="POuter_Box_Inventory">
              <div class="Purchaseheader">
                Search Result</div>
                <div id="divSearchResult">

             </div>
         </div>
                <div class="POuter_Box_Inventory" id="divSenttomrd" style="display:none">
                 <div class="row" style="text-align: center;">
                    <div class="col-md-24">
                     <input type="button" id="btnSave"  value="Sent To MRD" style="display:none;" class="ItDoseButton" onclick="SaveData()"/>
                        </div>
                 </div>
             
             
         </div>
         </div>
         
    <script  id="sptPatientSearch" type="text/html">
        <table id="tbl_PatientSearch" cellpadding="0" cellspacing="0" class="GridViewStyle" style="width:1291px">
            <thead>
                <tr>
                    
                    <th class="GridViewHeaderStyle">S.No.</th>
                    <th class="GridViewHeaderStyle">Ptype	</th>
                    <th class="GridViewHeaderStyle">IPDNo</th>
                      <th class="GridViewHeaderStyle">UHID No.</th>
                    <th class="GridViewHeaderStyle">Name</th>
                    <th class="GridViewHeaderStyle">Age/Sex	</th>
                     <th class="GridViewHeaderStyle">Contact</th>
                    <th class="GridViewHeaderStyle">Address</th>
                    <th class="GridViewHeaderStyle">Doctor Name</th>
                     <th class="GridViewHeaderStyle">Panel</th>
                    
                </tr>
            </thead>
            <tbody>
                <# 
                var DataLength=SearchResultData.length;
                window.status="Total Records Found :"+ DataLength;
                var dataObjRow;
                for( var i=0;i<DataLength;i++)
                    {
                    dataObjRow=SearchResultData[i];
                #>

                <tr id="<#=i+1#>"<#
                        if(dataObjRow.MRD_IsFile==1)
                        {#>
                         style="background-color:green"
                        <#}
                        else{#>
                         style="background-color:yellow"
                        <#}
                        #> >
                    
                    <td class="GridViewItemStyle"><#=i+1#></td>
                    <td class="GridViewItemStyle"  ><#=dataObjRow.type#>	</td>
                    <td class="GridViewItemStyle"><#=dataObjRow.TransNo#></td>
                     <td class="GridViewItemStyle" id="tdPatientId"><#=dataObjRow.PatientID#></td>
                    <td class="GridViewItemStyle"><#=dataObjRow.Pname#></td>
                    <td class="GridViewItemStyle"><#=dataObjRow.Age#>	</td>
                     <td class="GridViewItemStyle"><#=dataObjRow.Mobile#></td>
                    <td class="GridViewItemStyle"><#=dataObjRow.Address#></td>
                     <td class="GridViewItemStyle"><#=dataObjRow.DoctorName#></td>
                    <td class="GridViewItemStyle"><#=dataObjRow.Panel#></td>
                    
                    <td class="GridViewItemStyle" id="tdtransactionId" style="display:none"><#=dataObjRow.TransactionID#></td>
                </tr>
                   
 <#}#>
            </tbody>
        </table>
    </script>
    <script type="text/javascript">
        function SearchData() {
            var objSearch = new Object();
            objSearch.PatientId = $('#txtPatientID').val();
            objSearch.PatientName = $('#txtName').val();
            objSearch.AgeFrom = $('#txtAgeFrom').val();
            objSearch.AgeTo = $('#txtAgeTo').val();
            objSearch.DischargeType = $('#ddlDischageType').val();
            objSearch.RoomType = $('#cmbRoom').val();
            objSearch.DoctorId = $('#cmbDoctor').val();
            objSearch.TransactionId = $('#txtTransactionNo').val();
            objSearch.parentPanelId = $('#ddlParentPanel').val();
            objSearch.PanelId = $('#cmbCompany').val();
            objSearch.FromDate = $('#ucFromDate').val();
            objSearch.Todate = $('#ucToDate').val();
            objSearch.pType = $('#ddlPatientType').val();
            objSearch.FileStatus = $('#ddlStatus').val();
            var ISingnore=0;
            if($('#chkIgnore').is(':checked'))
            {
                ISingnore = 1;
            }
            $.ajax({
                url: 'Services/FileSentToMRD.asmx/MRDSentfilestatus',
                type: 'POST',
                data: JSON.stringify({ SearchData: objSearch, IsIgnore: ISingnore }),
                dataType: 'JSON',
                contentType: 'application/json; charset=utf-8',
                async: false,
                success: function (responce) {
                    SearchResultData = jQuery.parseJSON(responce.d);
                    if (SearchResultData != null) {
                        if (SearchResultData.length > 0) {
                            var OutPut = $("#sptPatientSearch").parseTemplate(SearchResultData);
                            $('#divSearchResult').html(OutPut);
                            $('#divSearchResult').show();
                            $('#<%=lblMsg.ClientID %>').text('');
                        } else {
                            $('#divSearchResult').html('');
                            $('#divSearchResult').hide();
                            $('#btnSave').hide();
                            modelAlert('Patient Record Not Found')
                    }
                    }
                    else {
                        $('#divSearchResult').html('');
                        $('#divSearchResult').hide();
                        $('#btnSave').hide();
                        modelAlert('Patient Record Not Found')
                    }
                   
                }
            });
        }
        function SaveData() {
            $('#btnSave').attr('disabled', 'disabled').val('submitting');
            var dataList = new Array();
            $('#tbl_PatientSearch tr').not(':first').each(function () {
                var row = $(this).closest('tr');     
                var objData = new Object();
                if (row.find('#chkSelect').is(':checked')) {
                    objData.PatientId = row.find('#tdPatientId').text();
                    objData.TransactionId = row.find('#tdtransactionId').text();
                    dataList.push(objData);
                }
            });
                    $.ajax({
                        url: 'Services/FileSentToMRD.asmx/SaveSentFile',
                        type: 'POST',
                        dataType: 'JSON',
                        data: JSON.stringify({Data:dataList }),
                        contentType: 'application/json; charset=utf-8',
                        async:false,
                        success: function (responce) {
                            SearchResultData = jQuery.parseJSON(responce.d);
                            if (SearchResultData != "0") {
                               
                                $('#btnSave').removeAttr('disabled').val('Send To MRD');
                                SearchData();
                                modelAlert('File Sent Successfully');
                                $('#<%=lblMsg.ClientID %>').focus;
                            }

                        },
                        error: function () {
                            $('#<%=lblMsg.ClientID %>').text('Have Some Error');
                            $('#btnSave').removeAttr('disabled').val('Send To MRD');
                        }
                    });
           
        }
        function ChkAll() {
            if ($('#chkAll').is(':checked')) {
                $('#tbl_PatientSearch tr').not(':first').each(function () {
                    $(this).closest('tr').find('#chkSelect').attr('checked', 'checked');
                });
                $('#divSenttomrd').show();
                $('#btnSave').show();
            }
            else {
                $('#tbl_PatientSearch tr').not(':first').each(function () {
                    $(this).closest('tr').find('#chkSelect').removeAttr('checked')
                });
                $('#btnSave').hide();
            }
        }
        function deSelect(rowId) {
          
            if ($(rowId).closest('tr').find('#chkSelect').is(':checked')) {
                $('#divSenttomrd').show();
                $('#btnSave').show();
            }
            else { $('#chkAll').removeAttr('checked'); }
            var count=0;
            $('#tbl_PatientSearch tr').not(':first').each(function () {
                if ($(this).closest('tr').find('#chkSelect').is('checked'))
                {
                    count++;
                }
            });
            //if(count==0)
            //    $('#btnSave').hide();
        }
    </script>
</asp:Content>

