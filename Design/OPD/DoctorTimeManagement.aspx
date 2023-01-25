<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorTimeManagement.aspx.cs" Inherits="Design_OPD_DoctorTimeManagement" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $bindCentre(function () {
                $('#ddlDepartment,#ddlDoctor,#ddlSpecialization,#ddlCentre').chosen({ width: '100%' });
            });
        });

        var $bindCentre = function (callback) {

            serverCall('../HelpDesk/Services/HelpDesk.asmx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                $Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: 'Select' });
                $bindDoctor($Centre.val(), function () {
                    callback($Centre.find('option:selected').text());
                });
            });
        }
        var $bindDoctor = function (centreId, callback) {
            serverCall('../common/CommonService.asmx/bindDoctorCentrewise', { CentreID: centreId }, function (response) {
                $Centre = $('#ddlDoctor');
                $Centre.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($Centre.find('option:selected').text());
            });
        }
        function searchDocTiming() {
            $("#lblErrormsg").text('');
            $.ajax({
                type: "POST",
                url: "../common/CommonService.asmx/DoctorTimingManagementDetails",
                data: '{doctorID:"' + $("#ddlDoctor").val() + '",Department:"' + $("#ddlDepartment").val() + '",Specialization:"' + $("#ddlSpecialization option:selected").text() + '",Centre:"' + $("#ddlCentre").val() + '",FromDate:"' + $("#txtFromDate").val() + '",ToDate:"' + $("#txtToDate").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    DocTiming = jQuery.parseJSON(response.d);
                    if (DocTiming != null) {
                        var output = $('#tb_DocTiming').parseTemplate(DocTiming);
                        $('#DocTimingOutput').html(output).customFixedHeader();;
                        $('#DocTimingOutput,#btncvs').show();

                    }
                    else {
                        DisplayMsg('MM04', 'lblErrormsg');
                        $('#DocTimingOutput,#btncvs').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }

    </script>
    <div id="Pbody_box_inventory">
         <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
         
        <div class="POuter_Box_Inventory" style="text-align: center;">
          
            <b>Doctor Time Detail</b><br />
            <asp:Label ID="lblErrormsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Creteria
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Centre  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:DropDownList ID="ddlCentre" onchange="$bindDoctor($('#ddlCentre').val(),function(){});" runat="server" ClientIDMode="Static">
                        </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Specialization   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlSpecialization" runat="server" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Department   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                  <div class="col-md-3">
                    <label class="pull-left"> Doctor </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:DropDownList ID="ddlDoctor" runat="server" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">From Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" ReadOnly="true" runat="server" ToolTip="Select From Date" ClientIDMode="Static" ></asp:TextBox>
                            <cc1:calendarextender ID="cdAppDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate" />
                                                                                                                   
                </div>
                 <div class="col-md-3">
                    <label class="pull-left">To Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" ReadOnly="true" runat="server" ToolTip="Select To Date" ClientIDMode="Static" ></asp:TextBox>
                            <cc1:calendarextender ID="Calendarextender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate" />
                                                                                                                   
                </div>
                
            </div>
             <div class="row">
                
                 <div class="col-md-3">
                  <label class="pull-left"></label>
                    <b class="pull-right"></b>  
                </div>
                 <div class="col-md-5">
                     
                     
                </div>
                 <div class="col-md-3">
                    <label class="pull-left"></label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5">
                   
                </div>
             </div>
            <div class="row">
                
            </div>
        </div>

        <div class=" POuter_Box_Inventory textCenter">
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-16"><input type="button" value="Search" class="margin-top-on-btn save" onclick="searchDocTiming()" /></div>
                <div class="col-md-4" style="text-align:right">
                    <asp:ImageButton ID="btncvs" runat="server" ImageUrl="~/Images/excelexport.gif" ClientIDMode="Static" Text="Export" style="display:none;width: 25px;" OnClick="btncvs_Click" />
                </div>
                </div>
        </div>

         <div class=" POuter_Box_Inventory textCenter">
             <div id="DocTimingOutput" style="max-height: 600px; overflow-x: auto;" runat="server" clientidmode="Static">
                </div>
             </div>

    </div>

    <script id="tb_DocTiming" type="text/html">

       <table  id="tableApp" cellspacing="0" clientidmode="Static" class="yui" style="width:100%;border-collapse:collapse;">
            <thead>
		   <tr class="tblTitle" id="Header">
               <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Centre</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Doctor Name</th>                
                <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Specialization</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Allocated Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Utilized Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Free Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Extra Time</th>  
			    
                   
		    </tr></thead>
            <#       
            var dataLength=DocTiming.length;
            window.status="Total Records Found :"+ dataLength;
            var objRow;   
            for(var j=0;j<dataLength;j++)
            {       
            objRow = DocTiming[j];
            #> <tbody>
                        <tr  id="<#=j+1#>" >                            
                            <td class="GridViewLabItemStyle" style="width:10px;"><input type="hidden" value="<#=objRow.DoctorID#>" class="doctorid" /><#=j+1#></td>                            
                            <td class="GridViewLabItemStyle" style="width:200px;" ><#=objRow.CentreName#></td>
                            <td class="GridViewLabItemStyle" style="width:170px;"><#=objRow.DName#></td>
                              <td class="GridViewLabItemStyle" style="width:170px;"><#=objRow.Specialization#></td>
                              <td class="GridViewLabItemStyle" style="width:170px;"><#=objRow.Date#></td>
                              <td class="GridViewLabItemStyle" style="width:170px;"><#=objRow.TotalTimeInSecAllocated#></td>
                              <td class="GridViewLabItemStyle" style="width:170px;"><#=objRow.TotalTimeInSecOccupied#></td>
                              <td class="GridViewLabItemStyle" style="width:170px;"><#=objRow.freetime#></td>
                            <td class="GridViewLabItemStyle" style="width:170px;"><#=objRow.extratime#></td>
                            
                        </tr>            
            <#}        
            #>      
         </tbody></table>  

    </script>
      
</asp:Content>

