<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MRDRequestApproval.aspx.cs" Inherits="Design_MRD_MRDRequestApproval" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
        #rejectRemarkPanel {
            z-index:10000;
            position:absolute;
            top:45%;
            left:30%;
            
            display:none;
            width:30%;
        }

    </style>   
     <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/CommonValidation.js" type="text/javascript"></script>
    <link href="../../Styles/CustomStyle.css" type="text/css" rel="stylesheet" />
      <script type="text/javascript">
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
          function BindFileRequest() {
              $("#<%=lblMsg.ClientID %>").text('');
              $("#btnSearch").val('Search....').attr("disabled", "disabled");
              var Status = "";
              var ReturnStatus = "";
              if ($("#rdoPending").is(':checked')) {
                  Status = 0
              }
              if ($("#rdoApproved").is(':checked')) {
                  Status = 1
              }
              if ($("#rdoRejected").is(':checked')) {
                  Status = 3
              }
              
              if ($("#rdSent").is(':checked')) {
                  ReturnStatus = 0
              }
              if ($("#rdReturn").is(':checked')) {
                  ReturnStatus = 1
              }
              $.ajax({
                  type: "POST",
                  url: "MRDRequestApproval.aspx/SearchMRDRequisition",
                  data: '{MRNo:"' + $.trim($("#txtPatientID").val()) + '",PName:"' + $.trim($("#txtPName").val()) + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '",fromDate:"' + $.trim($('#<%=txtFromDate.ClientID%>').val()) + '",toDate:"' + $.trim($('#<%=txtToDate.ClientID%>').val()) + '",MRDFileNo:"' + $.trim($("#txtMRDFileNo").val()) + '",Status:"' + Status + '",ReturnStatus:"' + ReturnStatus + '",pType:"' + $("#ddlPatientType").val() + '"}',
                dataType: 'json',
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    if (response.d != "") {
                        MRDsearch = jQuery.parseJSON(response.d);
                        if (MRDsearch != null) {
                       
                                var output = $('#tb_Searchpatient').parseTemplate(MRDsearch);
                                $('#bindtable').html(output);
                                $('#bindtable').show();
                                $("#btnSearch").removeAttr("disabled");
                                $("#lblMsg").text();
                                if ($("#rdoApproved").is(':checked')) {
                                    $("#tb_grdMRD").find('tr').find("th").each(function () {
                                        var id = $(this).closest("tr").attr("id");
                                        if (id == "Header") {
                                            $(this).closest("tr").find('#thstatus').text('UnApprove');
                                        }
                                    });
                                }
                            

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
            <b>MRD File Approval</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
       </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
              <div class="Purchaseheader">
                Search Criteria&nbsp;</div>
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
                            <input type="text" id="txtPatientID" tabindex="1" title="Enter Patient UHID NO." />
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
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtIPDNo" tabindex="2" title="Enter IPD No."  />
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                MRD File No.
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
                         <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" >  </cc1:CalendarExtender>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server"  TabIndex="5" ClientIDMode="Static" ToolTip="Select To Date"></asp:TextBox>
                         <cc1:CalendarExtender ID="calExeto" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"> Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <input type ="radio" id="rdoPending" value="0" name="group1" checked="checked" onclick="BindFileRequest()" />&nbsp;Pending
                        </div>
                         <div class="col-md-3">
                            <input type ="radio" id="rdoApproved" value="1" name="group1" onclick="BindFileRequest()" />&nbsp;Approved
                        </div>
                         <div class="col-md-3">
                            <input type ="radio" id="rdoRejected" value="3" name="group1" onclick="    BindFileRequest()" />&nbsp;Rejected
                        </div>
                        <div class="col-md-5"></div>
                        <div class="col-md-3">
                            <label class="pull-left">FileType</label>
                            <b class="pull-right">:</b>
                         </div>
                        <div class="col-md-2">
                        <input  type="radio" id="rdSent" value="0" checked="checked" name="group2"/>Sent
                        </div>
                         <div class="col-md-2">
                         <input  type="radio" id="rdReturn" value="1" name="group2"/>Return
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>

            </div>
              
            </div>
           <div class="POuter_Box_Inventory">
                <div class="row">
                     <div style="text-align: center;" class="col-md-24">
                     <input  type="button"  id="btnSearch" class="ItDoseButton" tabindex="7" title="Click to Search Patient" value="Search" onclick="BindFileRequest()"/>
                     <input type="button" value="Clear" onclick="clearAll()" class="ItDoseButton"/>
                 </div>
                 </div>
               </div>
            
                                   
            <div  class="POuter_Box_Inventory">
          <div class="Purchaseheader">
                Search Result&nbsp;</div>
            
                <div id="bindtable"></div>
               
        </div>
         </div>
        
    
     <script id="tb_Searchpatient" type="text/html">
            <div class="table-responsive table-cont">
            <table rules="all" border="1" class="GridViewStyle" id="tb_grdMRD" style="width:1292px">
		    <tr id="Header">
                 <#
                if( MRDsearch[0].IsApproved=="3")
                {
                #>
                <th class="GridViewHeaderStyle">Rejected By</th>
                <th class="GridViewHeaderStyle">Rejected Date</th>
                <#}
                else{
                #>
            <th class="GridViewHeaderStyle" id="thstatus">Approve</th>
               
            <th class="GridViewHeaderStyle">Reject</th>
                <#}#>
                <th class="GridViewHeaderStyle">Patient Type</th>
			<th class="GridViewHeaderStyle">UHID No</th>
            <th class="GridViewHeaderStyle">IPD No.</th>
            <th class="GridViewHeaderStyle">Patient Name</th>
            <th class="GridViewHeaderStyle">Gender / DOB</th>
            <th class="GridViewHeaderStyle">Requested Department</th>
            <th class="GridViewHeaderStyle">Requested By</th>
            <th class="GridViewHeaderStyle">Requested Date</th>
               
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
                    <tr id="<#=j+1#>" > 
                        <#if(objRow.IsApproved !="3"){#> 
                    <td class="GridViewItemStyle"><a>
                          <#if(objRow.IsApproved =="0"){#>  
                        <img src="../../Images/Post.gif"  onclick="showConfirmation('#<#=j+1#>')" />
                        <#}
                       else if(objRow.IsApproved =="1" && objRow.UnApproved == "1")
                        {#>  
                         <img src="../../Images/Post.gif"  onclick="StatusUpdate(this,2)" />
                          <#}#>         
                        </a>
                    </td>   
                        <td class="GridViewItemStyle"><a>
                            <#if(objRow.IsApproved =="0" && objRow.Rejected == "1"){#>  
                        <img src="../../Images/Delete.gif" onclick="showRemarkPanel('#<#=j+1#>')"/> 
                            <#}#> 
                            </a>
                    </td>  
                        <#}else{#>
                         <td  id="tdRejectedBy"><#=objRow.RejectedBy#></td>
                    <td  class="GridViewItemStyle" id="tdRejectedDate" ><#=objRow.RejectedDate#></td>
                         <#}#>
                        <td class="GridViewItemStyle" id="td2"><#=objRow.type#></td>
                    <td class="GridViewItemStyle" id="tdMRNo"><#=objRow.PatientID#></td>
                    <td class="GridViewItemStyle"  id="td1" ><#=objRow.TransNo#></td>
                    <td class="GridViewItemStyle" id="tdPatientName" ><#=objRow.PatientName#></td>
                    <td class="GridViewItemStyle" id="tdGender" ><#=objRow.Gender#> / <#=objRow.DOB#></td>
                    <td class="GridViewItemStyle" id="tdDeptName"><#=objRow.DeptName#></td>
                    <td class="GridViewItemStyle" id="tdRequestedBy" ><#=objRow.RequestedBy#></td>    
                    <td class="GridViewItemStyle" id="tdSRequestedDate"><#=objRow.RequestedDate#></td>
                        <td class="GridViewItemStyle" id="tdRequestID" style="display:none"><#=objRow.MRDRequisitionID#></td>
                        <td class="GridViewItemStyle"  id="tdIPDNo" style="display:none" ><#=objRow.TransactionID#></td>
                        <td  id="tdRemark" style="display:none;"><#=objRow.Remarks#></td>
                    </tr>           
        <#}       
        #>       
     </table>    </div>
    </script>
    <script type="text/javascript">
        function showRemarkPanel(rowid)
        {
            $('#rejectRemarkPanel').show();
            $('#btnReject').attr('onclick', 'StatusUpdate("' + rowid + '",3)')
        }
        function showConfirmation(rowid) {
            modelConfirmation('Confrim!!!', 'User Remark :' + $.trim($(rowid).closest('tr').find('#tdRemark').text()) + '<br/> Are you want to approve this', 'Yes', 'No', function (response) {
                if (response)
                {
                    StatusUpdate(rowid, 1);
                }
                //flag = response;
            });
        }
        function StatusUpdate(rowid,status)
        {
            var flag=true;
            if (status == 3)
            {
                if ($('#txtRejectRemark').val() == "") {
                    $("#lblMsg").text('Please Enter rejection Remark');
                    $('#txtRejectRemark').focus();
                       return;
                }
                else {
                    $('#rejectRemarkPanel').hide();
                    $("#lblMsg").text('');
                }
            }

            var ReturnStatus = "";
            if ($("#rdSent").is(':checked')) {
                ReturnStatus = 0
            }
            if ($("#rdReturn").is(':checked')) {
                ReturnStatus = 1
            }
            
            $('#rejectRemarkPanel').hide();
            var RequestID = $.trim($(rowid).closest('tr').find('#tdRequestID').text());
            var Remark = $('#txtRejectRemark').val();
            $.ajax({
                type: "POST",
                url: "MRDRequestApproval.aspx/ApprovedRequisition",
                data: '{RequestID:"' + RequestID + '",Status:"'+ status +'",Reason:"'+Remark+'",ReturnStatus:"'+ReturnStatus+'"}',
                  dataType: 'json',
                  contentType: "application/json;charset=UTF-8",
                  async: false,
                  success: function (response) {
                          MRDsearch = jQuery.parseJSON(response.d);
                          if (MRDsearch == "1") {
                              BindFileRequest();
                              if (status == 3)
                                  modelAlert('Requisition Rejected');
                              else if (status == 1)
                                  modelAlert('Requisition Approved');
                              else if (status == 2)
                                  modelAlert('Requisition UnApproved');
                          }
                          else {
                              $('#bindtable').hide();
                              modelAlert('Record Not Save');
                          }
                      }
              });
        }
        function clearAll() {
            $('#bindtable').hide();
            $('#txtPatientID').val('');
            $('#txtIPDNo').val('');
            $('#txtPatientName').val('');
            $('#txtMRDFileNo').val('');
          
        }
    </script>
    <div id="rejectRemarkPanel" class="pnlItemsFilter ">
      
            <div class="filterPupupBackground">
                 <div class="Purchaseheader">Reject Reason&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
            
            <em ><span style="font-size: 7.5pt">Press
            esc or click <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="ClosePopup()" /> to close</span></em></div>
           <div class="">
                <table>
                    <tr>
                        <td style="width:30%;text-align:right">Remark :&nbsp;</td>
                        <td style="width:30%;text-align:left"><input type="text" id="txtRejectRemark" /></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align:center;">
                            <input type="button" id="btnReject" class="ItDoseButton" value="Reject" />
                          <input type="button" id="btnCancel" onclick=" $('#rejectRemarkPanel').hide();"  class="ItDoseButton" value="Cancel" />
                
                        </td>
                    </tr>
                </table>
               
                  
               
                </div>

          </div>
      
    </div>

</asp:Content>

