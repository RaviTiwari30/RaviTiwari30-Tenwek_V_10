<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MRDFileIssue.aspx.cs" Inherits="Design_MRD_MRDFileIssue" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
  
   
    <style>
       .Box {
           height:20px;
           width:20px;
           float:left;
           margin:0px 10px;
       }
         .BoxContent {
              float:left;
           margin:0px 10px;
         }
   </style>
     <script>
         $(function () {
             $('#txtPatientID').focus();
             $('#txtFromDate').change(function () {
                 ChkDate();
             });

             $('#txtToDate').change(function () {
                 ChkDate();
             });
         });
         function ChkDate() {
             $.ajax({
                 url: "../common/CommonService.asmx/CompareDate",
                 data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
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
        function BindRequisition() {
            $("#btnSearch").val('Searching....').attr("disabled", "disabled");
            $.ajax({
                type: "POST",
                url: "MRDFileIssue.aspx/SearchRequisition",
                data: '{MRNo:"' + $.trim($("#txtPatientID").val()) + '",PName:"' + $.trim($("#txtPatientName").val()) + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '",fromDate:"' + $.trim($('#<%=txtFromDate.ClientID%>').val()) + '",toDate:"' + $.trim($('#<%=txtToDate.ClientID%>').val()) + '",MRDFileNo:"' + $.trim($("#txtMRDFileNo").val()) + '",pType:"' + $("#ddlPatientType").val() + '"}',
                dataType: 'json',
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    if (response.d != "") {
                        MRDsearch = jQuery.parseJSON(response.d);
                        if (MRDsearch != null) {
                            var output = $('#tb_Searchpatient').parseTemplate(MRDsearch);
                            $('#bindtable').html(output);
                            $('#bindtable').show();
                            $("#btnSearch").removeAttr("disabled");
                            $("#lblMsg").text();
                        }
                        else {
                            $('#bindtable').html('');
                            $('#bindtable').hide();
                           modelAlert('No Record Found');
                        }
                    }
                    else {
                        modelAlert('No Record Found');
                        $('#bindtable').html('');
                        $('#bindtable').hide();
                    }
                    $("#btnSearch").val('Search').removeAttr("disabled");
                },
                error: function (xhr, status) {
                    $("#btnSearch").val('Search').removeAttr("disabled");
                }
            });
        }
         function ReseizeIframe() {
             document.getElementById("iframePatient").style.width = "100%";
             document.getElementById("iframePatient").style.height = "100%";
             document.getElementById("iframePatient").style.display = "";
             document.getElementById("iframePatient").className = "panel-left";
         }
         function patientTypeID(el) {
             var pType = el;
             if (pType == 'OPD' || pType == 'ALL') {
                 $('#txtIPDNo').attr('disabled', 'disabled');
                 $('#txtIPDNo').val('');
             }
             else {

                 $('#lblPatientType').text(el + ' No');
                 $('#txtIPDNo').removeAttr('disabled');
                 $('#txtIPDNo').val('');
             }
         }
        </script>
<cc1:ToolkitScriptManager runat="Server" ID="ScriptManager1" EnableScriptGlobalization="true" EnableScriptLocalization="true" />
    <div id="Pbody_box_inventory">
        <div  class="POuter_Box_Inventory" style="text-align: center;">
           
            <b>MRD File Requisition Issue</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
               
       </div>
        <div  class="POuter_Box_Inventory">
              <div class="Purchaseheader">
              <b>Search Criteria</b> 
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
                            <asp:DropDownList ID="ddlPatientType" runat="server" ClientIDMode="Static" onchange="patientTypeID(this.value)"></asp:DropDownList>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                UHID NO
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientID" tabindex="1" title="Enter Patient UHID No." />
                        </div>

                         <div class="col-md-3">
                            <label class="pull-left">
                               Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientName"  tabindex="3" title="Enter Patient Name" />
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left" id="lblPatientType">
                               IPD No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtIPDNo" tabindex="2" title="Enter IPD No." />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               MRD File No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtMRDFileNo" tabindex="6" title="Enter MRD File No." />
                        </div>

                    </div>
                    <div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server"  TabIndex="4" ClientIDMode="Static" ToolTip="Select From Date"></asp:TextBox>
                         <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" >
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtToDate" runat="server"  TabIndex="5" ClientIDMode="Static" ToolTip="Select To Date"></asp:TextBox>
                         <cc1:CalendarExtender ID="calExeto" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                        </div>
                    </div>
                    </div>
                <div class="col-md-1"></div>
                </div>
               
            </div>
   <div class="POuter_Box_Inventory">
             <div class="row">
                     <div style="text-align: center;" class="col-md-24">
                     
                    <input  type="button"  id="btnSearch" class="ItDoseButton" tabindex="7" title="Click to Search Patient" value="Search" onclick="BindRequisition()"/>
                     <input type="button" value="Clear" class="ItDoseButton"/>
                 </div>
             </div>
                 <div >
                   
                      <div class="Box" style="background-color:yellow"></div> <div class="BoxContent">Already Issued</div>
                      <div class="Box" style="background-color:lightpink"></div> <div class="BoxContent">Not Issued</div> 
               </div>
         </div>
            
           
            <div  class="POuter_Box_Inventory">
             
                <div class="Purchaseheader">
                     <b> Search Result</b>
                </div>
           
              
                <div id="bindtable"></div>
              
        </div>
          </div>
       
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 0px; left: 0px; background-color: #FFFFFF; display: none;"
        frameborder="0" enableviewstate="true"></iframe>
       <script id="tb_Searchpatient" type="text/html">
            <div class="table-responsive table-cont">
            <table rules="all" border="1" id="tb_grdMRD" class="GridViewStyle" style="width:1292px">
		    <tr id="Header">
            <th class="GridViewHeaderStyle">Select</th>
            <th class="GridViewHeaderStyle">S.No.</th>
            <th class="GridViewHeaderStyle">PType</th>
			<th class="GridViewHeaderStyle">MRD.No</th>
            <th class="GridViewHeaderStyle">IPD No.</th>
            <th class="GridViewHeaderStyle">Patient Name</th>
            <th class="GridViewHeaderStyle">MRD File No.</th>
            <th class="GridViewHeaderStyle">Requested By / Approved By</th>
            <th class="GridViewHeaderStyle">Requested / Approved Date</th>
		</tr>
        <#       
        var dataLength=MRDsearch.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = MRDsearch[j];
        #>
                    <tr id="<#=j+1#>"<#
                        if(objRow.IsIssue==1)
                        {#>
                         style="background-color:yellow"
                        <#}
                        else{#>
                         style="background-color:lightpink"
                        <#}
                        #> >  
                    <td class="GridViewItemStyle"><a target="iframePatient" onclick="ReseizeIframe(this);" 
                        href="../MRD/MRDFolder.aspx?TID=<#=objRow.TransactionID#>&amp;PatientID=<#=objRow.PatientID#>&amp;LoginType=<#=objRow.LoginType#>&amp;Type=<#=objRow.Type#>&amp;RequestID=<#=objRow.MRDRequisitionID#>&amp;FrameID=7&amp;BillNo=<#=objRow.BillNo#>">
                        <%--href="Mrd_Home.aspx?TID=<#=objRow.TransactionID#>&amp;Patient_ID=<#=objRow.PatientID#>&amp;LoginType=<#=objRow.LoginType#>&amp;Type=<#=objRow.Type#>&amp;RequestID=<#=objRow.MRDRequisitionID#>&amp;FrameID=7&amp;BillNo=<#=objRow.BillNo#>">--%>
                    <img src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>
                       
                    </td>    
                    <td class="GridViewItemStyle"><#=j+1#></td>  
                     <td class="GridViewItemStyle" id="td1"><#=objRow.type#></td> 
                    <td class="GridViewItemStyle" id="tdMRNo"><#=objRow.PatientID#></td>
                    <td class="GridViewItemStyle" id="td15" ><#=objRow.TransNo#></td>
                    <td class="GridViewItemStyle" id="tdPatientName" ><#=objRow.PatientName#></td>
                    <td class="GridViewItemStyle" id="tdFileID" ><#=objRow.FileID#></td>
                    <td class="GridViewItemStyle" id="tdName"><#=objRow.RequestedName#> / <#=objRow.ApprovedBy#></td>
                    <td class="GridViewItemStyle" id="tdDate"><#=objRow.RejectedDate#> / <#=objRow.ApprovedDate#></td>
                        <td class="GridViewItemStyle" id="tdIPDNo" style="display:none" ><#=objRow.TransactionID#></td>
                    </tr>           
        <#}       
        #>       
     </table>    </div>
    </script>
</asp:Content>

